//
//  Preset.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/19/24.
//

import Foundation

struct Preset {
    var name: String
    var type: PresetType
}

enum PresetType: String, CaseIterable {
    case distance
    case volume
    case count
}


