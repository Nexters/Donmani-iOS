//
//  GoodCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

enum GoodCategory: String, CaseIterable, CategoryProtocol {
    case energy       // 활력
    case growth       // 성장
    case healing      // 힐링
    case happiness     // 소확행 (소소하지만 확실한 행복)
    case flex         // 플렉스
    case dignity      // 품위유지
    case affection    // 마음전달
    case health       // 건강
    case none   // 무소비
}

extension GoodCategory {
    var title: String {
        switch self {
        case .energy: return "활력"
        case .growth: return "성장"
        case .healing: return "힐링"
        case .happiness: return "소확행"
        case .flex: return "플렉스"
        case .dignity: return "품위유지"
        case .affection: return "마음전달"
        case .health: return "건강"
        case .none: return "없음"
        }
    }
    
    var assetName: String {
        self.rawValue
    }
    
    var dtoValue: String {
        self.rawValue.uppercased()
    }
}

extension GoodCategory: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        guard let value = GoodCategory(rawValue: rawValue.lowercased()) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid value: \(rawValue)"
            )
        }
        self = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue.uppercased())
    }
}

