//
//  SharedData.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/6/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

class SharedData: ObservableObject {
    @Published var coins: Int = 100
    @Published var petHunger: Int = 5
    @Published var petLikeness: Int = 5
    @Published var inventory: [String: Int] = [:]
    
    init() {
        loadPetData()
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func addToInventory(itemName: String) {
        inventory[itemName, default: 0] += 1
    }
    
    func removeFromInventory(itemName: String) {
        if let count = inventory[itemName], count > 0 {
            inventory[itemName] = count - 1
            if count - 1 == 0 {
                inventory.removeValue(forKey: itemName)
            }
        }
    }
    
    func savePetData() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        print("User ID: \(uId)")
        
        
        let db = Firestore.firestore()
        let petData: [String: Any] = [
            "coins": coins,
            "petHunger": petHunger,
            "petLikeness": petLikeness,
            "inventory": inventory
        ]
        db.collection("users")
            .document(uId)
            .collection("petData")
            .document("petStats")
            .setData(petData) { error in
                if let error = error {
                    print("Error saving pet data: \(error.localizedDescription)")
                } else {
                    print("Pet data saved successfully!")
                }
            }
    }
    
    func loadPetData() {
        guard let uId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users")
            .document(uId)
            .collection("petData")
            .document("petStats")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.coins = data?["coins"] as? Int ?? 100
                self.petHunger = data?["petHunger"] as? Int ?? 5
                self.petLikeness = data?["petLikeness"] as? Int ?? 5
                self.inventory = data?["inventory"] as? [String: Int] ?? [:]
                print("Pet data loaded successfully!")
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
