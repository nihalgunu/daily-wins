//
//  HomePageViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import FirebaseFirestore
import Foundation
import SwiftUI


class HomePageViewViewModel: ObservableObject {
    @Published var profileViewModel = ProfileViewViewModel()
    @Published var items: [ToDoListItem] = []
    
    private let userId: String
    private var timer: Timer?

    init(userId: String) {
        self.userId = userId
        loadItems()
        checkIfMidnightPassed()
        scheduleDailyUpdates()
    }
    
    deinit {
        timer?.invalidate() // Invalidate the timer when the view model is deallocated
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
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
    
    func loadItems() {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
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

    func checkIfMidnightPassed() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
        let now = Date()
        let calendar = Calendar.current

        if !calendar.isDate(lastResetDate, inSameDayAs: now) {
            resetAllTaskCompletion()
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
        }
    }

    func scheduleDailyUpdates() {
        let calendar = Calendar.current
        let now = Date()
        let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        
        timer = Timer(fireAt: nextMidnight, interval: 86400, target: self, selector: #selector(dailyUpdate), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }

    @objc private func dailyUpdate() {
        resetAllTaskCompletion()
    }
    
    func resetAllTaskCompletion() {
        for index in items.indices {
            items[index].isDone = false
            updateItemInFirestore(item: items[index])
        }
    }
    
    func updateItemInFirestore(item: ToDoListItem) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(item.id)
            .setData(item.asDictionary()) { error in
                if let error = error {
                    print("Error updating item: \(error.localizedDescription)")
                }
            }
    }
}

