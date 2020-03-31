//
//  ViewController.swift
//  Swift-Async-Await
//
//  Created by shin seunghyun on 2020/03/31.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // async-await in Swift
        do {
            let data = try fetchSomethingAsyncAwait()
            print(data!)
            print(String(decoding: data!, as: UTF8.self))
        } catch {
            print("Failed to fetch stuff:", error)
            return
        }
        
        do {
            let data = try fetchSomethingAsyncAwait()
            print(data!)
            print(String(decoding: data!, as: UTF8.self))
        } catch {
            print("Failed to fetch stuff:", error)
            return
        }
        
        do {
            let data = try fetchSomethingAsyncAwait()
            print(data!)
            print(String(decoding: data!, as: UTF8.self))
        } catch {
            print("Failed to fetch stuff:", error)
            return
        }
        
    }

    enum NetworkError: Error {
        case url
    }
    
    // async await fetch function
    func fetchSomethingAsyncAwait() throws -> Data? {
        guard let url = URL(string: "https://www.google.com") else { throw NetworkError.url }
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        // Semaphore - initialization
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (d, r, e) in
            data = d
            response = r
            error = e
            semaphore.signal() //Semaphore - Stop waiting
        }.resume()
        
        //Semaphore - Wait until the condition is met
        _ = semaphore.wait(timeout: .distantFuture)
        
        //Option - Advanced Programming
        if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode > 300 {
            throw NetworkError.url
        }
        
        //Option - Advanced Programming
        if let error = error {
            throw error
        }
        
        return data
    }
    
    
    // Normal Network Function
    func fetchSometing(completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: "https://www.google.com") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }

    
}

