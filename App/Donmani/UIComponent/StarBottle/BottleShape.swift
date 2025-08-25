//
//  BottleShape.swift
//  Donmani
//
//  Created by 문종식 on 8/17/25.
//

import DesignSystem

enum BottleShape {
    case `default`
    case bead
    case heart
    
    init(id: Int) {
        switch id {
        case 4:
            self = .default
        case 24:
            self = .bead
        case 25:
            self = .heart
        default:
            self = .default
        }
    }
    
    var imageAsset: DImageAsset {
        switch self {
        case .default:
                .rewardBottleDefaultShape
        case .bead:
                .rewardBottleBeadsShape
        case .heart:
                .rewardBottleFuzzyShape
        }
    }
}
