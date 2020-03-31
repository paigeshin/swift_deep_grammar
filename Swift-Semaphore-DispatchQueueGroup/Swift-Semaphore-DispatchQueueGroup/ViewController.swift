//
//  ViewController.swift
//  Swift-Semaphore-DispatchQueueGroup
//
//  Created by shin seunghyun on 2020/03/31.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sharedResource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        semaphoreExecution()
        
        print("Waiting for images to finish fetching...")
    }
    

    //Background로 multi threading을 할 때, 접근하는 resource가 수정이 많이되면 application이 crash할 가능성이 높음.
    func semaphoreExecution(){
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
    }
    
    //특정 공유된 데이터에 접근할 때는 dispatchGroup을 쓰기에 부적절하다.
    func dispatchGroupExecution(){
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
        
    }
    
    func fetchImage(completion: @escaping(UIImage?, Error?) -> ()) {
        
        guard let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQM5DnbpohOxyV70-6Pc_BW5DwdCiJi6t9ts0V3_3nObG2yitu0&usqp=CAU")
            else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            completion(UIImage(data: data ?? Data()), nil)
            
        }.resume()
        
    }


}

