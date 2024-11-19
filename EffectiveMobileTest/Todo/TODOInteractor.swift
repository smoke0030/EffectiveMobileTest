import Foundation
import Alamofire
import ProgressHUD

protocol TODOInteractorProtocol: AnyObject {
    func loadData(completion: @escaping ([TodoModel]) -> Void)
    func deleteTodo(index: IndexSet, completion: @escaping (Int) -> Void)
    func completeTodo(todo: TodoModel, completion: @escaping (Int) -> Void)
    func getTodos(completion: @escaping ([TodoModel]) -> Void)
    func addTodo(name: String, completion: @escaping (TodoModel) -> Void)
    func editTodo(id: Int, newName: String, completion: @escaping ((TodoModel, Int)) -> Void)
    func getTodosFromDB(completion: @escaping ([TodoModel]) -> Void)
}

final class TODOInteractor: TODOInteractorProtocol {
    
    weak var presenter: TodoPresenterProtocol?
    
    var networkManager: NetworkSeviceProtocol {
        return NetworkService()
    }
    
    let todoStore = TodoStore.shared
    
    func loadData(completion: @escaping ([TodoModel]) -> Void) {
        networkManager.getData { result in
            switch result {
            case .success(let objects):
                for todo in objects.todos {
                    TodoStore.shared.addTodo(todo: todo)
                }
                completion(objects.todos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получение списка задач
    func getTodosFromDB(completion: @escaping ([TodoModel]) -> Void) {
            let newTodos = TodoStore.shared.fetchTodo()
            let todos = TodoStore.shared.convertToTodo(todos: newTodos)
        completion(todos)
    }
    
    func getTodos(completion: @escaping ([TodoModel]) -> Void) {
        getTodosFromDB { object in
            completion(object)
        }
        }
    
    func getRandomId() -> Int {
        let id = Int.random(in: 1...100)
        return id
    }
    
    //удаление задачи
    func deleteTodo(index: IndexSet, completion: @escaping (Int) -> Void) {
        guard let firstIndex = index.first,
        let todo = self.presenter?.todos[firstIndex] else { return }
        DispatchQueue.global().async {
            TodoStore.shared.deleteTodo(with: todo.id)
        }
        completion(firstIndex)
    }
    
    //добавление задачи
    func addTodo(name: String, completion: @escaping (TodoModel) -> Void) {
        var id = getRandomId()
        presenter?.todos.forEach {
            if $0.id == id {
                id = getRandomId()
            }
        }
        TodoStore.shared.addTodo(id: id, name: name, date: Date())
        let newTodo = TodoModel(id: id, todo: name, completed: false, userId: 111)
        completion(newTodo)
        
    }
    
    //заверешние задачи
    func completeTodo(todo: TodoModel, completion: @escaping (Int) -> Void) {
        let index = self.presenter?.todos.firstIndex { $0.id == todo.id }
        if let index = index {
            TodoStore.shared.completeTodo(todo: todo)
            completion(index)
        }
    }
    
    //редактирование задачи
    func editTodo(id: Int, newName: String, completion: @escaping ((TodoModel, Int)) -> Void) {
        guard let index = presenter?.todos.firstIndex(where: { $0.id == id }),
            let todoForEdit = presenter?.todos[index] else { return }
        
        TodoStore.shared.editTodo(id: id, newName: newName)
        let newTodo = TodoModel(id: todoForEdit.id,
                                todo: newName,
                                completed: todoForEdit.completed,
                                userId: todoForEdit.userId,
                                date: todoForEdit.date)
        completion((newTodo, index))
    }
}
