//
//  ContentView.swift
//  Daily-Wins
//
//  Created by Nihal Gunukula on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                ToDoListView(userId: viewModel.currentUserId)
                    .tabItem() {
                        Label("Home", systemImage: "house")
                    }
                ProfileView()
                    .tabItem() {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
