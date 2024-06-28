//
//  RegisterViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMsg = ""
    
    init() {
        
    }
    
    func register() {
        guard validate() else {
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] result, error in guard let userId = result?.user.uid else {
                self?.errorMsg = error?.localizedDescription ?? "Unknown error"
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
        
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMsg = "Please fill in all fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMsg = "Please enter a valid email address"
            return false
        }
        
        guard password.count >= 6 else {
            errorMsg = "Please enter a password of at least 6 characters"
            return false
        }
        
        return true
    }
}
