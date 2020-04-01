# swift_deep_grammar

# DispatchGroup vs Semaphore 

https://www.notion.so/DispatchGroup-f7d1aa2278a44ead8275b6c3ce6924b0
        
https://www.notion.so/Semaphore-64b0edff29514ccd9602ef8bec1ddf56
        
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



### Swift `where` keyword

https://www.notion.so/Swift-Where-Keyword-a22631558ee44cc3bafe46bf84be4372

`switch`

    enum Action {
        case createUser(age: Int)
        case createPost
        case logout
    }
    
    func printAction(action: Action){
        switch action {
            case .createUser(let age) where age < 21:
                print("Young and wild!")
            case .createUser:
                print("Older and wise!")
            case .createPost:
                print("Creating a post")
            case .logout:
                print("Log out")
        }
    }

`for loop`

    let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    for number in numbers where number % 2 == 0 {
            print(number)
    }

`extension` 

    extension Array where Element == Int {
        func printAverageAge()[
            let total = reduce(0, +)
            let average = total / count 
            print("Average age is \(average)")
        }
    }
    
    let ages = [20, 15, 45, 32, 67]
    ages.printAverageAge()

`Array.contains`

    let fruits = ["Banana", "Apple", "Kiwi"]
    let containsBanana = fruits.contains(where: {(fruit) in 
            return fruit == "Banana"
    })
    
    

### Swift Async Fuction 만들기

https://www.notion.so/Swift-Async-Await-da6f50269f774d5782d7f3c28bdfd7d5

    // async await fetch function
    func fetchSomethingAsyncAwait() throws -> Data? {
        guard let url = URL(string: "https://www.google.com") else { throw NetworkError.url }
        
        var data: Data?
        
        // Semaphore - initialization
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (d, r, e) in
            data = d
    
            semaphore.signal() //Semaphore - Stop waiting
        }.resume()
        
        //Semaphore - Wait until the condition is met
        _ = semaphore.wait(timeout: .distantFuture)
        
        return data
    }

- `closure` 을 사용하지 않는다.
- `semaphore` 를 사용.

### inout keyword

    import UIKit
        
        class Employee {
            var name: String
            var age: Int
            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }
        
        //Swift에서 기본적으로 parameter로 들어오는 값은 `let` constant 이다. 그래서 값을 바꿀 수 없다.
        //아래 코드는 error가 발생하는 코드.
        /*
        func changeEmployeeData(emp: Employee){
            emp = Employee(name: "Suneet", age: 25)
        }
        */
        
        func changeEmployeeData(emp: inout Employee){
            emp = Employee(name: "Charles", age: 15)
        }
        
        var employee1 = Employee(name: "Brian", age: 24)

1. 기본적으로 swift에서 function의 parameter 값은 `let` 으로 선언 되어 있음
2. parameter로 들어온 값을 변경하려면 `inout` keyword를 사용한다.

