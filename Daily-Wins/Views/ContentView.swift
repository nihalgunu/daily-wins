//
//  ContentView.swift
//  Daily-Wins
//
//  Created by Nihal Gunukula on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()   
    @StateObject var sharedData = SharedData()
    @StateObject var userViewModel = UserViewModel()

    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                HomePageView(userId: viewModel.currentUserId)
                    .tabItem() {
                        Label("Home", systemImage: "house")
                    }
                    .environmentObject(userViewModel)
                PetView()
                    .tabItem() {
                        Label("YourPet", systemImage: "dog")
                    }
                    .environmentObject(sharedData)
                    .foregroundColor(.primary)
            }
            .environmentObject(sharedData)
            .environmentObject(userViewModel)

        } else {
            LoginView()
        }
    }
}

#Preview {
    return ContentView()
        .preferredColorScheme(.dark)
}
