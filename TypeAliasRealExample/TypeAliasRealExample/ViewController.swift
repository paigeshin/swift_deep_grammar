//
//  ViewController.swift
//  TypeAliasRealExample
//
//  Created by shin seunghyun on 2020/04/01.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    typealias ImageFromServer = (UIImage?, Error?) -> Void

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData { (image, error) in
            
        }
        
    }
    
    func fetchData(completion: @escaping ImageFromServer) {
        guard let url = URL(string: "https://www.google.com") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(UIImage(data: data ?? Data()), error)
        }
    }

}

