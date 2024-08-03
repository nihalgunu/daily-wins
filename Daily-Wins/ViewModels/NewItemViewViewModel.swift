//
//  NewItemViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewItemViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var tracking = Int()
    @Published var reminder: [TimeInterval] = []
    //@Published var isDone: Bool = false
    @Published var showAlert: Bool = false
    
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create a model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(id: newId, title: title, description: description, tracking: tracking, reminder: reminder, isDone: false)
        
        // Save the model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary()) { error in
                if let error = error {
                    print("Error saving item to Firestore: \(error.localizedDescription)")
                } else {
                    print("Item saved successfully: \(newItem)")
                }
            }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        /*guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }*/
        return true
    }
}
