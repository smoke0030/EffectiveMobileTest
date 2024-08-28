//
//  ViewModel.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 23.08.2024.
//

import Foundation

final class ViewModel: ObservableObject {
    
    @Published var todos: [TODO] = []
    
    // получение списка задач
    func getTodos(completion: @escaping () -> Void) {
        guard let newTodos = TodoStore.shared.fetchTodo() else { return }
        todos = TodoStore.shared.convertToTodo(todos: newTodos)
        TodoStore.shared.log()
        completion()
    }
    
    //метод для рандомных id
    func getRandomId() -> Int {
        let id = Int.random(in: 1...100)
        return id
    }
    
    //удаление задачи
    func deleteTodo(index: IndexSet) {
        guard let firstIndex = index.first else { return }
        let todoOnDelete = todos[firstIndex]
        todos.remove(atOffsets: index)
        DispatchQueue.global().async {
            TodoStore.shared.deleteTodo(with: todoOnDelete.id)
        }
        
    }
    
    //добавление задачи
    func addTodo(name: String) {
        var id = getRandomId()
        todos.forEach {
            if $0.id == id {
                id = getRandomId()
            }
        }
        TodoStore.shared.addTodo(id: Int16(id), name: name)
        todos.append(TODO(id: id, todo: name, completed: false, userId: 111))
        
    }
    
    //заверешние задачи
    func completeTodo(todo: TODO) {
        let index = todos.firstIndex { $0.id == todo.id }
        if let index = index {
            todos[index].completed.toggle()
        }
        TodoStore.shared.completeTodo(todo: todo)
        
    }
    
    //получение задач при первом входе и внесение их в базу 
    func getData() {
        NetworkService.shared.getData { result in
            switch result {
            case .success(let object):
                self.todos = object.todos
                for todo in object.todos {
                    TodoStore.shared.addTodo(id: Int16(todo.id), name: todo.todo)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
