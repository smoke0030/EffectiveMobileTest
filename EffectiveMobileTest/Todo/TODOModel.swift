//
//  TODOModel.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 18.11.2024.
//

import Foundation

struct TodoModelResponse: Decodable {
    var todos: [TodoModel]
}

struct TodoModel: Decodable, Identifiable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
    var date: Date?
}
