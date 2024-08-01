//
//  ToDoListItem.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import Foundation

struct ToDoListItem: Codable, Identifiable {
    let id: String
    var title:String
    var description: String
    var tracking: Int
    var reminder: [TimeInterval] = []
    //let dueDate: TimeInterval
    //let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
