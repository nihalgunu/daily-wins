//
//  HomePageViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import FirebaseFirestore
import Foundation

class HomePageViewViewModel: ObservableObject {
    @Published var profileViewModel = ProfileViewViewModel()
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete() 
    }
}
