import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Daily Wins")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                
                // Image
                Image("file")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle()) // Optional, if you want the image to be circular
                    .padding(.bottom, 20)
                
                Spacer()
                
                // Login Form
                VStack(spacing: 15) {
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Create Account
                NavigationLink(destination: RegisterView()) {
                    Text("Create An Account")
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}
