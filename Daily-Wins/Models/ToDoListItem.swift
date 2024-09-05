//
//  ToDoListItem.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import Foundation

struct ToDoListItem: Codable, Identifiable, Equatable {
    let id: String
    var title:String
    var description: String
    var tracking: Int
    var reminder: [TimeInterval] = []
    var progress: Int
    var isDone: Bool
    var unit: String
    var useCustom: Bool
    //var customUnit: String
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "description": description,
            "tracking": tracking,
            "reminder": reminder,
            "progress": progress,
            "isDone": isDone,
            "unit": unit,
            "useCustom": useCustom
        ]
    }
}
