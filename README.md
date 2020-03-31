# swift_deep_grammar

# DispatchGroup vs Semaphore 

        
❗️DispatchGroup으로 Multi-threading을 돌리면서 shared resource에 접근하려하면 에러가 발생할 수 있다.

⇒ 그런 이유 때문에 `Semaphore` 를 사용한다.
❗️ 단 `Semaphore` 를 사용하려고해도, 접근하는 데이터가 많이 바꾸면 문제가 생길 수 있음.

###  DispatchGroup

- background task에 순서를 줄 수 있음.

            import UIKit
            
            class ViewController: UIViewController {
            
                var sharedResource = [String]()
                
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    //DispatchGroup - Async Await 같은 개념
                    let dispatchGroup = DispatchGroup()
                    
                    dispatchGroup.enter()
                    
                    fetchImage { (image, error) in
                        print("Finished fetching image 1")
                        dispatchGroup.leave()
                    }
                    
                    
                    dispatchGroup.enter()
                    fetchImage { (image, error) in
                        print("Finished fetching image 2")
                        dispatchGroup.leave()
                    }
                    
                    
                    dispatchGroup.enter()
                    fetchImage { (image, error) in
                        print("Finished fetching image 3")
                        dispatchGroup.leave()
                    }
                    
                    //Notify, Async Await같은 개념
            
                    dispatchGroup.notify(queue: .main) {
                        print("Finished fetching images.")
                    }
                    
                    print("Wating for images to finish fetching...")
                    
                }
                
                func fetchImage(completion: @escaping(UIImage?, Error?) -> ()) {
                    
                    guard let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQM5DnbpohOxyV70-6Pc_BW5DwdCiJi6t9ts0V3_3nObG2yitu0&usqp=CAU")
                        else { return }
                    
                    URLSession.shared.dataTask(with: url){(data, response, error) in
                        
                        completion(UIImage(data: data ?? Data()), nil)
                        
                    }.resume()
                    
                }

- 사용법
    1. DispatchGroup의 instance를 만든다.
    2. Background task가 실행되기 전의 코드에 `enter()` method를 호출
    3. Background task가 끝났을 때 `leave()` method를 호출
    4. 모든 Background task가 끝나는 부분에 `notify()` 를 호출한다.


### Semaphore

        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background) //background에서 작업을 하도록 지시
        
        dispatchQueue.async {
            self.fetchImage { (image, error) in
                print("Finished fetching image 1")
                self.sharedResource.append("1")
                semaphore.signal()
            }
            semaphore.wait()
            self.fetchImage { (image, error) in
                print("Finished fetching image 2")
                self.sharedResource.append("2")
                semaphore.signal()
            }
            semaphore.wait()
            self.fetchImage { (image, error) in
                print("Finished fetching image 3")
                self.sharedResource.append("3")
                semaphore.signal()
            }
            semaphore.wait()
        }

- 사용법
    1. semaphore를 `0` 의 값을 주고 instance화 
    2. DispatchQueue에 `background`로 작업을 하도록 option 값을 제공하고 instance 화
    3. dispatchQueue.async 코드 블록을 만듬
    4. 각각의 background task가 끝나는 부분에 `signal()` 메소드 호출
    5. 새로운 background task가 시작하기 전에 `wait()` 메소드 호출
