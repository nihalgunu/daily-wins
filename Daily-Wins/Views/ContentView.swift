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
                HomePageView(userId: viewModel.currentUserId)
                    .tabItem() {
                        Label("Home", systemImage: "house")
                    }
                TreeView()
                    .tabItem() {
                        Label("Tree", systemImage: "tree")
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
