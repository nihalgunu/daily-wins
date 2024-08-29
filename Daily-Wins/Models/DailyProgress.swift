//
//  DailyProgress.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/26/24.
//

import Foundation
import FirebaseFirestoreSwift

class DailyProgress: Identifiable, Codable {
    var id: String? = UUID().uuidString
    var date: Date
    var tasksTotal: Int
    var tasksFinished: Int
    //var streaks: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case tasksTotal
        case tasksFinished
        //case streaks
    }
    
    init(date: Date, tasksTotal: Int, tasksFinished: Int) {
        self.date = date
        self.tasksTotal = tasksTotal
        self.tasksFinished = tasksFinished
        //self.streaks = streaks
    }
}


