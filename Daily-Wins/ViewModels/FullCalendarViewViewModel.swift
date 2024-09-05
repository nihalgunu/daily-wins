//
//  FullCalendarViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/26/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI

class FullCalendarViewViewModel: ObservableObject {
    @Published var dailyProgress: [DailyProgress] = []
    
    var userViewModel: UserViewModel = UserViewModel()
    
    init() {}
    
    func updateStreaks() -> Int {
        // Sort the dailyProgress by date
        let sortedProgress = dailyProgress
            .filter { !Calendar.current.isDateInToday($0.date) }  // Exclude today's date
            .sorted { $0.date < $1.date }
        var streak = 0

        for progress in sortedProgress {
            // Check if the user completed all tasks on that day
            if progress.tasksTotal > 0 && progress.tasksFinished == progress.tasksTotal {
                streak += 1;

            } else {
                streak = 0;
            }
        }
        return streak
    }

    
    func saveProgress(date: Date, tasksTotal: Int, tasksFinished: Int) {
            guard let userId = userViewModel.userId else {
                print("User ID is not available")
                return
            }
                
            let db = Firestore.firestore()

            let progress = DailyProgress(date: date, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
    
            do {
                let docRef = db.collection("users")
                    .document(userId)
                    .collection("dailyProgress")
                    .document(dateFormatter.string(from: date))
    
                try docRef.setData(from: progress) { error in
                    if let error = error {
                        print("Error saving progress: \(error.localizedDescription)")
                    } else {
                        print("Progress saved successfully for \(self.dateFormatter.string(from: date))")
                    }
                }
            } catch let error {
                print("Error writing progress to Firestore: \(error.localizedDescription)")
            }
        }

    
    func loadProgress() {
        guard let userId = userViewModel.userId else {
            print("User ID is not available")
            return
        }

        let db = Firestore.firestore()

        // Fetch all progress data
        db.collection("users")
            .document(userId)
            .collection("dailyProgress")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error loading progress: \(error.localizedDescription)")
                    return
                }

                self.dailyProgress = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: DailyProgress.self)
                } ?? []
            }
    }

    
    // DateFormatter for Firestore document ID
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

    
//    private var db = Firestore.firestore()
//    
//    init() {
//        print("User ID in ViewModel: \(userViewModel.userId ?? "No userId found")")
//        //loadProgress()
//    }

//func saveProgress() {
//    guard let uId = Auth.auth().currentUser?.uid else {
//        return
//    }
//    
//    let db = Firestore.firestore()
//    let progressData = DailyProgress(date: date, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
//    
//    db.collection("users")
//        .document(uId)
//        .collection("dailyProgress")
//        .document(dateFormatter.string(from: date))
//        .setData(progressData.asDictionary()) { error in
//            if let error = error {
//                print("Error saving item to Firestore: \(error.localizedDescription)")
//            } else {
//                print("Item saved successfully: \(progressData)")
//            }
//        }
//}
//
//    func saveProgress(date: Date, tasksTotal: Int, tasksFinished: Int) {
//        guard let userId = userViewModel.userId else {
//            print("User ID is not available")
//            return
//        }
//        
//        let progress = DailyProgress(date: date, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
//        
//        do {
//            let docRef = db.collection("users")
//                .document(userId)
//                .collection("dailyProgress")
//                .document(dateFormatter.string(from: date))
//            
//            try docRef.setData(from: progress) { error in
//                if let error = error {
//                    print("Error saving progress: \(error.localizedDescription)")
//                } else {
//                    print("Progress saved successfully for \(self.dateFormatter.string(from: date))")
//                }
//            }
//        } catch let error {
//            print("Error writing progress to Firestore: \(error.localizedDescription)")
//        }
//    }
//    
//    func loadProgress() {
//        guard let userId = userViewModel.userId else {
//            print("User ID is not available")
//            return
//        }
//
//        db.collection("users")
//            .document(userId)
//            .collection("dailyProgress")
//            .getDocuments { (snapshot, error) in
//                if let error = error {
//                    print("Error loading progress: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else {
//                    print("No documents found")
//                    return
//                }
//
//                self.dailyProgress = documents.compactMap { doc in
//                    let progress = try? doc.data(as: DailyProgress.self)
//                    print("Loaded progress for date \(doc.documentID): \(String(describing: progress))")
//                    return progress
//                }
//            }
//    }

    
//    func loadProgress(for month: Date) {
//        guard let userId = userViewModel.userId else {
//            print("User ID is not available")
//            return
//        }
//        
//        let calendar = Calendar.current
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
//        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
//
//        db.collection("users")
//            .document(userId)
//            .collection("dailyProgress")
//            .whereField("date", isGreaterThanOrEqualTo: startOfMonth)
//            .whereField("date", isLessThan: endOfMonth)
//            .getDocuments { (snapshot, error) in
//                if let error = error {
//                    print("Error loading progress: \(error.localizedDescription)")
//                    return
//                }
//
//                self.dailyProgress = snapshot?.documents.compactMap { doc in
//                    try? doc.data(as: DailyProgress.self)
//                } ?? []
//            }
//    }
    



