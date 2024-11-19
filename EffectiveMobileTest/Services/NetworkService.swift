
import Foundation
import Alamofire

protocol NetworkSeviceProtocol: AnyObject {
    func getData(completion: @escaping (Result<TodoModelResponse, Error>) -> Void)
}
  
final class NetworkService: NetworkSeviceProtocol {
    
    private let url = "https://dummyjson.com/todos"
    
    func getData(completion: @escaping (Result<TodoModelResponse, Error>) -> Void) {
        DispatchQueue.global().async {
            
            if let url = URL(string: self.url) {
                AF.request(url).responseDecodable(of: TodoModelResponse.self) { response in
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
