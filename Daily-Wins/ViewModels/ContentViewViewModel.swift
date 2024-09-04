//
//  ContentViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import FirebaseAuth
import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self]  _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
            }
        }
        checkUser()
    }
    
    public func checkUser() {
        if let user = Auth.auth().currentUser {
            DispatchQueue.main.async {
                self.currentUserId = user.uid
            }
        } else {
            DispatchQueue.main.async {
                self.currentUserId = ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
