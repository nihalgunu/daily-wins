//
//  ToDoListViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

// ViewModel for list of items view
// Primary tab
class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func deleteItem(item: ToDoListItem) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(item.id)
            .delete()
    }
}
