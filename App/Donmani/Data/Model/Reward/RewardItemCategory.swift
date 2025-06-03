//
//  RewardItemCategory.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

enum RewardItemCategory: String, CaseIterable {
    case background
    case effect
    case decoration
    case byeoltong
    case sound
    
    var title: String {
        switch self {
        case .background:
            return "배경"
        case .effect:
            return "효과"
        case .decoration:
            return "장식"
        case .byeoltong:
            return "별통이"
        case .sound:
            return "효과음"
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "EFFECT":
            self = .effect
        case "CASE":
            self = .byeoltong
        case "BACKGROUND":
            self = .background
        case "BGM":
            self = .sound
        case "DECORATION":
            self = .decoration
        default:
            self = .background
        }
    }
}

