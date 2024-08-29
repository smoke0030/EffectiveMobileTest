//
//  ViewModel.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 23.08.2024.
//

import Foundation
import ProgressHUD

final class ViewModel: ObservableObject {
    
    @Published var todos: [TODO] = []
    @Published var isPresentedAlert = false
    @Published var name = ""
    @Published var isEditing = false
    @Published var editingTodo: TODO?
   
    
    // получение списка задач
    func getTodos(completion: @escaping () -> Void) {
        ProgressHUD.animate()
            let newTodos = TodoStore.shared.fetchTodo()
            self.todos = TodoStore.shared.convertToTodo(todos: newTodos)
        completion()
        ProgressHUD.dismiss()
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
        TodoStore.shared.addTodo(id: Int16(id), name: name, date: Date())
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
    
    func editTodo(id: Int, newName: String) {
        guard let index = todos.firstIndex(where: { $0.id == id }) else { return }
        
        todos[index].todo = newName
        print(todos[index].todo)
        TodoStore.shared.editTodo(id: id, newName: newName)
        
       
        
    }
    //получение задач при первом входе и внесение их в базу
    func getData() {
        ProgressHUD.animate()
        NetworkService.shared.getData { result in
            switch result {
            case .success(let object):
                self.todos = object.todos
                for todo in object.todos {
                    TodoStore.shared.addTodo(todo: todo)
                }
                ProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                ProgressHUD.dismiss()
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        let stringDate = formatter.string(from: date)
        return stringDate
    }
}
