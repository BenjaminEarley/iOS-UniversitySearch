//
//  APIClient.swift
//  todoapp
//
//  Created by Benjamin Earley on 12/21/18.
//  Copyright © 2018 Benjamin Earley. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
    private let baseURL = URL(string: "http://universities.hipolabs.com/")!
    
    func send<T: Codable>(apiRequest: APIRequest) -> Single<T> {
        return Single<T>.create { [unowned self] single in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    single(.success(model))
                } catch let error {
                    single(.error(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
