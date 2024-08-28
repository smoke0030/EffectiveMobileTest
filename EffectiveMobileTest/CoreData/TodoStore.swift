//
//  TodoStore.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 27.08.2024.
//

import UIKit
import CoreData

final class TodoStore: NSObject {
    static let shared = TodoStore()
    private override init() {
        super.init()
    }
    
    private var context: NSManagedObjectContext {
        PersistenceController.shared.containter.viewContext
    }
    
    private func fetchRequest() -> NSFetchRequest<TodoCoreData> {
        let request = NSFetchRequest<TodoCoreData>(entityName: "TodoCoreData")
        return request
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print("failed save to coreData", error.localizedDescription)
        }
    }
    
    
    //поиск задач в базе
    func fetchTodo() -> [TodoCoreData]? {
        let request = fetchRequest()
        var todos: [TodoCoreData] = []
        request.returnsObjectsAsFaults = false
        
        do {
            todos = try context.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return todos
    }
    
    func fetchTodo(with id: Int) -> TodoCoreData? {
        let request = fetchRequest()
        var object: [TodoCoreData] = []
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            object =  try context.fetch(request)
        } catch let error as NSError {
            assertionFailure("failed search from CoreData, \(error.localizedDescription)")
        }
        
        return object.first
    }
    
    //метод для извлечения пути к базе(для просмотра через DB browses for SQLite)
    public func log() {
        if let url = PersistenceController.shared.containter.persistentStoreCoordinator.persistentStores.first?.url {
            print(url)
        }
    }
    
    //конвертирование модели CoreData в модель TODO
    func convertToTodo(todos: [TodoCoreData]) -> [TODO] {
        var returnedTodos: [TODO] = []
        for todo in todos {
            let id = Int(todo.id)
            let name = todo.name ?? ""
            let userId = Int(todo.usedId)
            let isCompleted = todo.isCompleted
            
            let newTodo = TODO(id: id, todo: name, completed: isCompleted, userId: userId)
            returnedTodos.append(newTodo)
        }
        return returnedTodos
    }
    
    //добавление задачи в базу
    func addTodo(id: Int16, name: String) {
        let newTodo = TodoCoreData(context: context)
        newTodo.id = id
        newTodo.name = name
        newTodo.isCompleted = false
        newTodo.usedId = Int16(1012)
        
       saveContext()
    }
    
    //удаление задачи из базы
    func deleteTodo(with id: Int) {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let objects = try context.fetch(request)
            context.delete(objects[0])
        } catch let error as NSError {
            assertionFailure("failed delete from CoreData, \(error.localizedDescription)")
        }
        saveContext()
    }
    
    func completeTodo(todo: TODO) {
        if let object = fetchTodo(with: todo.id) {
            object.isCompleted.toggle()
        }
        saveContext()
        
    }
}
