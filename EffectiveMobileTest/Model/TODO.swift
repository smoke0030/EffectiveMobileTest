//
//  TODO.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 23.08.2024.
//

import Foundation


struct Response: Decodable {
    
    var todos: [TODO]
}
struct TODO: Decodable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
    var date: Date?
}
