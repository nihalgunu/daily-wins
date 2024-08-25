//
//  DailyUpdates.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/24/24.
//

import Foundation

class DailyUpdates {
    
    var item: ToDoListItem
    
    init(item: ToDoListItem) {
        self.item = item
    }
    
    func scheduleCheckMark(date: Date) {
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: date)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        // Get midnight
        let now = Date()
        let midnight = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
        
        // Timer
        let timer = Timer(fireAt: midnight, interval: 86400, target: self, selector: #selector(resetTaskCompletion), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)

    }
    
    @objc func resetTaskCompletion() {
        item.isDone = false
    }
    
    func checkIfMidnightPassed() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
        let now = Date()
        let calendar = Calendar.current

        if !calendar.isDate(lastResetDate, inSameDayAs: now) {
            resetTaskCompletion()
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
        }
    }
}
