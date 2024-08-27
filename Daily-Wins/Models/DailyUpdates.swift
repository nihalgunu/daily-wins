//
//  DailyUpdates.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/24/24.
//

import Foundation

// moved to HomePageViewViewModel

//class DailyUpdates {
//    
//    var item: ToDoListItem
//    @Published var tasksTotal = 0
//    @Published var tasksFinished = 0
//    
//    init(item: ToDoListItem) {
//        self.item = item
//        checkIfMidnightPassed()
//        scheduleDailyUpdates()
//    }
//    
//    func scheduleDailyUpdates() {
//        let calendar = Calendar.current
//        let now = Date()
//        let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
//        
//        let timer = Timer(fireAt: nextMidnight, interval: 86400, target: self, selector: #selector(dailyUpdate), userInfo: nil, repeats: true)
//        RunLoop.main.add(timer, forMode: .common)
//    }
//    
//    @objc private func dailyUpdate() {
//        if item.isDone {
//            tasksFinished += 1
//        }
//        tasksTotal += 1
//        resetTaskCompletion()
//    }
//    
//    @objc private func resetTaskCompletion() {
//        item.isDone = false
//    }
//    
//    func checkIfMidnightPassed() {
//        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
//        let now = Date()
//        let calendar = Calendar.current
//
//        if !calendar.isDate(lastResetDate, inSameDayAs: now) {
//            resetTaskCompletion()
//            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
//        }
//    }
//}

