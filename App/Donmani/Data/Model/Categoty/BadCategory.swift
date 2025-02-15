//
//  BadCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

enum BadCategory: String, CaseIterable, Codable, CategoryProtocol {
    case greed         // 욕심
    case addiction     // 중독
    case laziness      // 게으름
    case impulsive     // 충동
    case useless       // 무의미
    case vanity        // 과시
    case badHabit      // 습관반복
    case forcedSaving  // 억지절약
    case noSpending    // 무소비
}

extension BadCategory {
    var title: String {
        switch self {
        case .greed: return  "욕심"
        case .addiction: return  "중독"
        case .laziness: return  "게으름"
        case .impulsive: return  "충동"
        case .useless: return  "무의미"
        case .vanity: return  "과시"
        case .badHabit: return "습관반복"
        case .forcedSaving: return  "과한절약"
        case .noSpending: return  "무소비"
        }
    }
    
    var assetName: String {
        self.rawValue
    }
}
