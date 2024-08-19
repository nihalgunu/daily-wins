//
//  SharedData.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/6/24.
//

import SwiftUI
import Foundation

class SharedData: ObservableObject {
    @Published var coins: Int = 100
    @Published var petHunger: Int = 5
    @Published var petLikeness: Int = 5
    @Published var inventory: [String: Int] = [:]
    
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
}
