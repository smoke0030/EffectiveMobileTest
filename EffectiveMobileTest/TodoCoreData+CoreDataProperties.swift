//
//  TodoCoreData+CoreDataProperties.swift
//  
//
//  Created by Сергей on 19.11.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TodoCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoCoreData> {
        return NSFetchRequest<TodoCoreData>(entityName: "TodoCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var usedId: Int16

}

extension TodoCoreData : Identifiable {

}
