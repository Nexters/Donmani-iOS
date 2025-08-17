//
//  RecordCategory.swift
//  Donmani
//
//  Created by 문종식 on 8/15/25.
//

import Foundation
import SwiftUI
import DesignSystem

enum RecordCategory: String {
    // 행복 소비
    /// 활력
    case energy
    /// 성장
    case growth
    /// 힐링
    case healing
    /// 소확행 (소소하지만 확실한 행복)
    case happiness
    /// 플렉스
    case flex
    /// 품위유지
    case dignity
    /// 마음전달
    case affection
    /// 건강
    case health
    /// 절약
    case saving
    
    // 후회 소비
    /// 욕심
    case greed
    /// 중독
    case addiction
    /// 게으름
    case laziness
    /// 충동
    case impulse
    /// 무의미
    case meaninglessness
    /// 과시
    case boastfulness
    /// 습관반복
    case habit
    /// 과한절약
    case overfrugality
    /// 선택미스
    case miss
    
    /// 무소비
    case none
}

extension RecordCategory {
    var uppercaseValue: String {
        self.rawValue.uppercased()
    }
    
    var assetName: String {
        self.rawValue
    }
    
    public var hashValue: Int {
        title.hashValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
    }
    
    var color: Color {
        DColor(self.assetName.convertUppercaseFirstChar + "Color").color
    }
    
    var sticker: Image {
        let name = self.assetName.convertUppercaseFirstChar + "Sticker"
        return DImage(name).image
    }
    
    var miniSticker: Image {
        let name = self.assetName.convertUppercaseFirstChar + "MiniSticker"
        return DImage(name).image
    }
}

extension RecordCategory {
    static var badCategory: [RecordCategory] {
        [
            .greed, .addiction, .laziness,
            .impulse, .meaninglessness, .boastfulness,
            .habit, .overfrugality, .miss
        ]
    }
    
    static var goodCategory: [RecordCategory] {
        [
            .energy, .growth, .healing,
            .happiness, .flex, .dignity,
            .affection, .health, .saving
        ]
    }
    
    static func cases(type: RecordContentType) -> [RecordCategory] {
        switch type {
        case .good:
            RecordCategory.goodCategory
        case .bad:
            RecordCategory.badCategory
        }
    }
}

// Title
extension RecordCategory {
    var title: String {
        switch self {
        case .energy:           "활력"
        case .growth:           "성장"
        case .healing:          "힐링"
        case .happiness:        "소확행"
        case .flex:             "플렉스"
        case .dignity:          "품위유지"
        case .affection:        "마음전달"
        case .health:           "건강"
        case .saving:           "절약"
            
        case .greed:            "욕심"
        case .addiction:        "중독"
        case .laziness:         "게으름"
        case .impulse:          "충동"
        case .meaninglessness:  "무의미"
        case .boastfulness:     "과시"
        case .habit:            "습관반복"
        case .overfrugality:    "과한절약"
        case .miss:             "선택미스"
            
        case .none:             "없음"
        }
    }
}
