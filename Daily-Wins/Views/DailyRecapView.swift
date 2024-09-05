//
//  DailyRecapView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 9/3/24.
//

import SwiftUI
import FirebaseFirestore

struct DailyRecapView: View {
    @EnvironmentObject var contentModel: ContentViewViewModel
    
    @State private var isNavigating = false
    @State var streaks = Int()
    
    @Binding var showDailyRecap: Bool
    
    private let dateKey = "lastRecapDate"
    
    @FirestoreQuery var items: [ToDoListItem]
    
    init(showDailyRecap: Binding<Bool>, userId: String) {
        self._showDailyRecap = showDailyRecap
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }

    var body: some View {
        Text("Daily Recap")
            .font(.largeTitle)
            .padding()
        VStack {
            VStack {
                let sortedItems = items.sorted { !$0.isDone && $1.isDone }
                let completedItems = sortedItems.filter { $0.isDone }
                let incompleteItems = sortedItems.filter { !$0.isDone }
                                            
                if !completedItems.isEmpty {
                    Text("Wins Completed")
                    ForEach(completedItems) { item in
                        Text("\(item.title)")
                    }
                }
                if !incompleteItems.isEmpty {
                    Text("Wins Incompleted")
                    ForEach(incompleteItems) { item in
                        Text("\(item.title)")
                    }
                }
            }
        }
        .onTapGesture {
            isNavigating = true
            showDailyRecap = false
        }
        .fullScreenCover(isPresented: $isNavigating) {
            HomePageView(userId: contentModel.currentUserId)
       }
        
//            .onAppear {
//                let lastRecapDate = UserDefaults.standard.object(forKey: dateKey) as? Date ?? Date.distantPast
//                let today = Calendar.current.startOfDay(for: Date())
//                
//                if lastRecapDate < today {
//                    showDailyRecap = true
//                    UserDefaults.standard.set(Date(), forKey: dateKey)
//                } else {
//                    showDailyRecap = false
//                }
//            }
    }
}

#Preview {
    @State var showingDailyRecap = Bool()
    
    return DailyRecapView(showDailyRecap: $showingDailyRecap, userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
}
