//
//  HomePageViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import FirebaseFirestore
import Foundation

class HomePageViewViewModel: ObservableObject {

    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}
