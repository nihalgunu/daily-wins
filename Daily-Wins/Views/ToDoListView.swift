//
//  ToDoListItemsView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import FirebaseFirestoreSwift
import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel : ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    var body: some View {
        NavigationView {
            VStack {
                if items.isEmpty {
                    Text("Tap '+' to add your first todo")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(items) { item in
                        ToDoListItemView(item: item)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("To Dos")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

#Preview {
    ToDoListView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
}
