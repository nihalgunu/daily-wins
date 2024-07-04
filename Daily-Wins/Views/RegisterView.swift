//
//  RegisterView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Image(systemName: "tree.fill")
                    .foregroundColor(.green)
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
            .padding(.top, 50)

            Spacer()
            
            // Registration Form
            VStack(spacing: 16) {
                TextField("Full Name", text: $viewModel.name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                TextField("Email Address", text: $viewModel.email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                if !viewModel.errorMsg.isEmpty {
                    Text(viewModel.errorMsg)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(8)
                        .padding(.bottom, 10)
                }
                
                TLButton(title: "Create Account", background: .green) {
                    viewModel.register()
                }
                .padding(.top, 20)
                .frame(width: 200, height: 50) // Consistent button size
                .cornerRadius(8)
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    RegisterView()
}
