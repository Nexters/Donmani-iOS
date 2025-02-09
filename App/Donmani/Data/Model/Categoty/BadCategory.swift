//
//  BadCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

enum BadCategory: String, CaseIterable, Codable, CategoryProtocol {
    var title: String {
        switch self {
        case .overspending: return  "과소비"
        case .addiction: return  "중독"
        case .dopamineRush: return  "도파민"
        case .impulsive: return  "충동"
        case .laziness: return  "게으름"
        case .vanity: return  "과시"
        case .useless: return  "무쓸모"
        case .greed: return  "욕심"
        case .inefficiency: return  "비효율"
        case .forcedSaving: return  "억지절약"
        case .noSpending: return  "무소비"
        case .etc: return  "기타"
        }
    }
    
    case overspending   // 과소비
    case addiction      // 중독
    case dopamineRush   // 도파민 (순간적인 쾌락)
    case impulsive      // 충동
    case laziness       // 게으름
    case vanity         // 과시
    case useless        // 무쓸모
    case greed          // 욕심
    case inefficiency   // 비효율
    case forcedSaving   // 억지절약
    case noSpending     // 무소비
    case etc            // 기타
}
