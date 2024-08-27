//
//  FullCalendarViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/26/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class FullCalendarViewViewModel: ObservableObject {
    @Published var dailyProgress: [DailyProgress] = []
    
    var userViewModel: UserViewModel = UserViewModel()
    
    private var db = Firestore.firestore()

    init() {
        print("User ID in ViewModel: \(userViewModel.userId ?? "No userId found")")
        //loadProgress()
    }

    func saveProgress(date: Date, tasksTotal: Int, tasksFinished: Int) {
        guard let userId = userViewModel.userId else {
            print("User ID is not available")
            return
        }
        
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
    
    func loadProgress(for month: Date) {
        guard let userId = userViewModel.userId else {
            print("User ID is not available")
            return
        }
        
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

        db.collection("users")
            .document(userId)
            .collection("dailyProgress")
            .whereField("date", isGreaterThanOrEqualTo: startOfMonth)
            .whereField("date", isLessThan: endOfMonth)
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


