//
//  ContentView.swift
//  Daily-Wins
//
//  Created by Nihal Gunukula on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeModel = HomePageViewViewModel()
    @StateObject var viewModel = ContentViewViewModel()
    @StateObject var sharedData = SharedData()
    @StateObject var userViewModel = UserViewModel()
    
    @State private var showDailyRecap = true
    
    var body: some View {
        if showDailyRecap {
            DailyRecapView(showDailyRecap: $showDailyRecap)
                .environmentObject(viewModel)
                .environmentObject(sharedData)
                .environmentObject(userViewModel)
        }
        else if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                HomePageView(userId: viewModel.currentUserId)
                    .tabItem() {
                        Label("Home", systemImage: "house")
                    }
                    .environmentObject(userViewModel)
                    .environmentObject(homeModel)
                PetView()
                    .tabItem() {
                        Label("YourPet", systemImage: "dog")
                    }
                    .environmentObject(sharedData)
                    .foregroundColor(.primary)
            }
            .environmentObject(sharedData)
            .environmentObject(userViewModel)
            .environmentObject(homeModel)
        } else {
            LoginView()
        }
    }
    
}

#Preview {
    return ContentView()
        .preferredColorScheme(.dark)
}

//        if showDailyRecap {
//            DailyRecapView(showDailyRecap: $showDailyRecap)
//                .environmentObject(viewModel)
//                .environmentObject(sharedData)
//                .environmentObject(userViewModel)
//        }
//        else
