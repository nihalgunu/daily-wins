//
//  ProfileView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/26/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    // Avatar
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.blue)
                        .frame(width: 125, height: 125)
                    // Info: Name, email, Member since
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name: ")
                            Text(user.name)
                        }
                        
                        HStack {
                            Text("Email: ")
                            Text(user.email)
                        }
                        
                        HStack {
                            Text("Member Since: ")
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                        }
                    }
                    // Sign out Button
                    
                    Button("Log Out") {
                        viewModel.logOut()
                    }
                    .tint(.red)
                    
                    Spacer()
                } else {
                    Text("Loading Profile...")
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

#Preview {
    ProfileView()
}
