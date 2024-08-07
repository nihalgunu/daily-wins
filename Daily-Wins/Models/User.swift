//
//  User.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/26/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
    //let profileImageUrl: String?
}
