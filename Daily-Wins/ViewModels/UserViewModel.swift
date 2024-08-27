//
//  UserViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/26/24.
//

import Foundation

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var userId: String?
    
    init() {
        self.userId = Auth.auth().currentUser?.uid
    }
}
