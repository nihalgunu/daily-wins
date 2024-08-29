//
//  HomePageViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation
import SwiftUI


class HomePageViewViewModel: ObservableObject {
    @Published var profileViewModel = ProfileViewViewModel()
    @Published var items: [ToDoListItem] = []
    @Published var streaks = Int()
    
    private let calendar = Calendar.current
    private let dateKey = "lastUpdateDate"
    
    //private let userId: String

    init() {
        loadItems()
    }
    
    func saveItems() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        
        for item in items {
            let documentId = item.id.isEmpty ? UUID().uuidString : item.id
            db.collection("users")
                .document(uId)
                .collection("todos")
                .document(documentId)
                .setData(item.asDictionary()) { error in
                    if let error = error {
                        print("Error saving item \(item.title): \(error.localizedDescription)")
                    } else {
                        print("Item \(item.title) saved successfully!")
                    }
                }
        }
    }

    func loadItems() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("todos")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading items: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    self.items = documents.compactMap { document in
                        try? document.data(as: ToDoListItem.self)
                    }
                }
            }
    }
    
    func checkForDailyUpdate() {
        let lastUpdateDate = UserDefaults.standard.object(forKey: dateKey) as? Date ?? Date.distantPast
        if !calendar.isDateInToday(lastUpdateDate) {
            var count = 0
            for index in items.indices {
                if items[index].isDone == true {
                    count += 1
                    items[index].isDone = false
                }
            }
            if count ==  items.count {
                streaks += 1
            }
            //saveItems()
            UserDefaults.standard.set(Date(), forKey: dateKey)
        }
    }
    
    func delete(id: String) {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(id)
            .delete() { error in
                if let error = error {
                    print("Error deleting item: \(error.localizedDescription)")
                } else {
                    self.loadItems()
                }
            }
    }
}

//func checkIfMidnightPassed() {
//    let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
//    let now = Date()
//    let calendar = Calendar.current
//
//    if !calendar.isDate(lastResetDate, inSameDayAs: now) {
//        resetAllTaskCompletion()
//        UserDefaults.standard.set(Date(), forKey: "lastResetDate")
//    }
//}
//
//func scheduleDailyUpdates() {
//    let calendar = Calendar.current
//    let now = Date()
//    let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
//    
//    timer = Timer(fireAt: nextMidnight, interval: 86400, target: self, selector: #selector(dailyUpdate), userInfo: nil, repeats: true)
//    RunLoop.main.add(timer!, forMode: .common)
//}
//
//@objc private func dailyUpdate() {
//    resetAllTaskCompletion()
//}
//
//func resetAllTaskCompletion() {
//    for index in items.indices {
//        items[index].isDone = false
//        updateItemInFirestore(item: items[index])
//    }
//}
//
//func updateItemInFirestore(item: ToDoListItem) {
//    let db = Firestore.firestore()
//    db.collection("users")
//        .document(userId)
//        .collection("todos")
//        .document(item.id)
//        .setData(item.asDictionary()) { error in
//            if let error = error {
//                print("Error updating item: \(error.localizedDescription)")
//            }
//        }
//}

//    @Published var timerCounting: Bool = false
//    @Published var startTime: Date?
//    @Published var stopTime: Date?
//
//    let userDefaults = UserDefaults.standard
//    let START_TIME_KEY = "start time"
//    let STOP_TIME_KEY = "stop time"
//    let COUNTING_KEY = "count time"

//func setStartTime(date: Date?) {
//    startTime = date
//    userDefaults.set(startTime, forKey: START_TIME_KEY)
//}
//
//func setStopTime(date: Date?) {
//    stopTime = date
//    userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
//}
//
//func setTimerCounting(_ val: Bool) {
//    timerCounting = val
//    userDefaults.set(timerCounting, forKey: STOP_TIME_KEY)
//}
//func load() {
//    startTime = userDefaults.object
//}
