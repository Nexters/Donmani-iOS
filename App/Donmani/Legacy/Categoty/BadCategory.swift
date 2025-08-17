//
//  BadCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

//enum BadCategory: String, CaseIterable, CategoryProtocol {
//    case greed            // 욕심
//    case addiction        // 중독
//    case laziness         // 게으름
//    case impulse          // 충동
//    case meaninglessness  // 무의미
//    case boastfulness     // 과시
//    case habit            // 습관반복
//    case overfrugality    // 과한절약
//    case miss             // 선택미스
//    case none             // 무소비
//}
//
//
//extension BadCategory {
//    var title: String {
//        switch self {
//        case .greed: return  "욕심"
//        case .addiction: return  "중독"
//        case .laziness: return  "게으름"
//        case .impulse: return  "충동"
//        case .meaninglessness: return  "무의미"
//        case .boastfulness: return  "과시"
//        case .habit: return "습관반복"
//        case .overfrugality: return  "과한절약"
//        case .miss: return  "선택미스"
//        case .none: return  "없음"
//        }
//    }
//    
//    var assetName: String {
//        self.rawValue
//    }
//    
//    var uppercaseValue: String {
//        self.rawValue.uppercased()
//    }
//    
//    static let set = Set(allCases.map{$0.rawValue.uppercased()})
//}
