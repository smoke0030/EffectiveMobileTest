
import XCTest
import Alamofire
@testable import EffectiveMobileTest

struct Response: Decodable {
    let todos: [Todo]
}

struct Todo: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

protocol Networking {
    func getData(completion: @escaping (Result<Response, Error>) -> Void)
}

final class MockNetworkService: Networking {
    var shouldReturnError = false
    var mockResponse: Response?

    func getData(completion: @escaping (Result<Response, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
        } else if let response = mockResponse {
            completion(.success(response))
        }
    }
}

class NetworkServiceTests: XCTestCase {
    
    var sut: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        sut = MockNetworkService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGetDataSuccess() {
        let expectation = self.expectation(description: "Get data from API")
        
        let todosResponse = Response(todos: [
            Todo(id: 1, todo: "Do something nice for someone you care about", completed: false, userId: 152),
            Todo(id: 2, todo: "Memorize a poem", completed: true, userId: 13)
        ])
        
        sut.mockResponse = todosResponse
        
        sut.getData { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.todos[0].todo, "Do something nice for someone you care about")
                XCTAssertFalse(response.todos[0].completed)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but received failure: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testGetDataFailure() {
        let expectation = self.expectation(description: "Get data from API")
    
        sut.shouldReturnError = true
        
        sut.getData { result in
            switch result {
            case .success:
                XCTFail("Expected failure but received success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
