//
//  HomePageView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import FirebaseFirestore
import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel : HomePageViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    @State private var currentDate = Date()

    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomePageViewViewModel(userId: userId))
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }

    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                    .frame(height:50)
                
                WeeklyCalendarView()
                
                NavigationLink(destination: {
                    FullCalendarView(currentDate: $currentDate)
                }, label: {
                    Text("Expand>>")
                        .padding(.leading, 300)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                })

                Spacer()
                    .frame(height: 100)
                HStack {
                    Text("Dailys")
                        .padding(.trailing, 300)
                    
                    NavigationLink(destination: {
                        ToDoListView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
                    }, label: {
                        Image(systemName: "plus")
                       })

                }
                List(items) {item in
                    ToDoListItemView(item: item)
                    .padding()                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the list takes available space
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomePageView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
}
