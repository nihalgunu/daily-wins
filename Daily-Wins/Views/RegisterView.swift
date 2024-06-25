//
//  RegisterView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct RegisterView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "Register", backgroundColor: .gray)
            
            Form {
                TextField("Full Name", text: $name)
                    .textFieldStyle(DefaultTextFieldStyle())
                TextField("Email Address", text: $email)
                    .textFieldStyle(DefaultTextFieldStyle())
                TextField("Password", text: $password)
                    .textFieldStyle(DefaultTextFieldStyle())
            }
            .offset(y:50)
            
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
