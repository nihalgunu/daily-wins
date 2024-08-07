//
//  ContentView.swift
//  Daily-Wins
//
//  Created by Nihal Gunukula on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()   
    @StateObject var sharedData = SharedData() // Create the shared data model
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                HomePageView(userId: viewModel.currentUserId)
                    .tabItem() {
                        Label("Home", systemImage: "house")
                    }
                PetView()
                    .tabItem() {
                        Label("YourPet", systemImage: "pet")
                    }
                    .environmentObject(sharedData)
            }
            .environmentObject(sharedData)

        } else {
            LoginView()
        }
    }
}

#Preview {
    return ContentView()
}
