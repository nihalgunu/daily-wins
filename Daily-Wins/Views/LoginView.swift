//
//  LoginView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Daily Wins")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color.blue.opacity(0.2).colorInvert().colorMultiply(Color.blue))
                .cornerRadius(10)
                .padding(.top, 50)
                
                Spacer()
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(8)
                        .padding(.bottom, 10)
                }

                // Login Form
                VStack(spacing: 16) {
                    TextField("Email Address", text: $viewModel.email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    TLButton(title: "Log In", background: .blue) {
                        viewModel.login()
                    }
                    .padding(.top, 20)
                    .frame(width: 200, height: 50) // Increased the size of the login button
                    .cornerRadius(8)
                }
                .padding(.horizontal, 32)
                
                Spacer()

                // Create Account
                VStack {
                    Text("New user?")
                        .foregroundColor(.gray)
                    
                    NavigationLink("Create An Account", destination: RegisterView())
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                }
                .padding(.bottom, 50)
            }
            .padding()
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    LoginView()
}
