//
//  ContentView.swift
//  Daily-Wins
//
//  Created by Nihal Gunukula on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    
    //@Binding var description: String
    
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
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    //@State var previewDescription = String()

    return ContentView()
}
