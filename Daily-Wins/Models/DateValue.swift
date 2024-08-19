//
//  DateValue.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/1/24.
//

import SwiftUI

// Date Value Model

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

import Foundation

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let satiation: Int
}

struct StoreItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let likeness: Int
}
