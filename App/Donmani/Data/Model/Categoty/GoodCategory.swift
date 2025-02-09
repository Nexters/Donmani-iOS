//
//  GoodCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

enum GoodCategory: String, CaseIterable, Codable, CategoryProtocol {
    var title: String {
        switch self {
        case .energy: return "에너지"
        case .focus: return "집중"
        case .growth: return "성장"
        case .smallJoy: return "소확행"
        case .flex: return "플렉스"
        case .healing: return "힐링"
        case .dignity: return "품위유지"
        case .affection: return "마음전달"
        case .celebration: return "축하"
        case .health: return "건강"
        case .noSpending: return "무소비"
        case .etc: return "기타"
        }
    }
    
    case energy       // 에너지
    case focus        // 집중
    case growth       // 성장
    case smallJoy     // 소확행 (소소하지만 확실한 행복)
    case flex         // 플렉스
    case healing      // 힐링
    case dignity      // 품위유지
    case affection    // 마음전달
    case celebration  // 축하
    case health       // 건강
    case noSpending   // 무소비
    case etc          // 기타
}
