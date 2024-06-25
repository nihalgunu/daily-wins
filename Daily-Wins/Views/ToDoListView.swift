//
//  ToDoListItemsView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel = ToDoListViewViewModel()
    
    init() {
        
    }
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .navigationTitle("To Do List")
            .toolbar {
                Button {
                    // Action
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

#Preview {
    ToDoListView()
}
