import Foundation
import ProgressHUD

protocol TodoPresenterProtocol: AnyObject {
    var todos: [TodoModel] { get set }
    func getTodos()
}

class TODOPresenter: ObservableObject, TodoPresenterProtocol {
    
    @Published var todos: [TodoModel] = []
    @Published var isPresentedAlert = false
    @Published var name = ""
    @Published var searchText = ""
    @Published var isEditing = false
    @Published var editingTodo: TodoModel?
    
    var filteredItems: [TodoModel] {
        if searchText.isEmpty {
            return todos
        } else {
            return todos.filter({ $0.todo.lowercased().contains(searchText.lowercased() )})
        }
    }
    
    var interactor: TODOInteractorProtocol
    
    init(interactor: TODOInteractorProtocol) {
        self.interactor = interactor
    }
    
    func getData() {
        ProgressHUD.animate()
        interactor.loadData { result in
            self.todos = result
            ProgressHUD.dismiss()
        }
    }
    
    func getTodos() {
        interactor.getTodos { todos in
            self.todos = todos
            if self.todos.isEmpty {
                self.getData()
            }
        }
    }
    
    func deleteTodo(with index: IndexSet) {
        interactor.deleteTodo(index: index) { todoIndex in
            DispatchQueue.main.async {
                self.todos.remove(at: todoIndex)
            }
        }
    }
    
    func completeTodo(todo: TodoModel) {
        interactor.completeTodo(todo: todo) { index in
            DispatchQueue.main.async {
                self.todos[index].completed.toggle()
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    func addTodo(name: String) {
        interactor.addTodo(name: name) { todo in
            DispatchQueue.main.async {
                self.todos.append(todo)
            }
        }
    }
    
    func editTodo(id: Int, newName: String) {
        interactor.editTodo(id: id, newName: newName) { newTodo, index in
            DispatchQueue.main.async {
                self.todos[index] = newTodo
            }
        }
    }
}
