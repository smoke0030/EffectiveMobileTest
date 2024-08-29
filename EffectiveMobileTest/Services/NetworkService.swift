//
//  NetworkService.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 24.08.2024.
//

import Foundation
import Alamofire
  
final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let url = "https://dummyjson.com/todos"
    
    func getData(completion: @escaping (Result<Response, Error>) -> Void) {
        DispatchQueue.global().async {
            
            if let url = URL(string: self.url) {
                AF.request(url).responseDecodable(of: Response.self) { response in
                    switch response.result {
                    case .success(let object):
                        completion(.success(object))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
