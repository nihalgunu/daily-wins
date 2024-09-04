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
    @Binding var showDailyRecap: Bool
    
    private let dateKey = "lastRecapDate"
    
//    @FirestoreQuery var items: [ToDoListItem]
//    
//    init(showDailyRecap: Binding<Bool>, userId: String) {
//        self._showDailyRecap = showDailyRecap
//        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
//    }


    var body: some View {
        
        Text("Daily Recap")
            .font(.largeTitle)
            .padding()
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                isNavigating = true
                showDailyRecap = false
            }
            .fullScreenCover(isPresented: $isNavigating) {
                HomePageView(userId: contentModel.currentUserId)
           }
            .onAppear {
                let lastRecapDate = UserDefaults.standard.object(forKey: dateKey) as? Date ?? Date.distantPast
                let today = Calendar.current.startOfDay(for: Date())
                
                if lastRecapDate < today {
                    showDailyRecap = true
                    UserDefaults.standard.set(Date(), forKey: dateKey)
                } else {
                    showDailyRecap = false
                }
            }
    }
}

//#Preview {
//    @
//    DailyRecapView()
//}
