//
//  BadCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

enum BadCategory: String, CaseIterable, CategoryProtocol {
    case greed            // 욕심
    case addiction        // 중독
    case laziness         // 게으름
    case impulse          // 충동
    case meaninglessness  // 무의미
    case boastfulness     // 과시
    case habit            // 습관반복
    case overfrugality    // 과한절약
    case miss             // 선택미스
    case none             // 무소비
}

extension BadCategory {
    var title: String {
        switch self {
        case .greed: return  "욕심"
        case .addiction: return  "중독"
        case .laziness: return  "게으름"
        case .impulse: return  "충동"
        case .meaninglessness: return  "무의미"
        case .boastfulness: return  "과시"
        case .habit: return "습관반복"
        case .overfrugality: return  "과한절약"
        case .miss: return  "선택미스"
        case .none: return  "없음"
        }
    }
    
    var assetName: String {
        self.rawValue
    }
    
    var dtoValue: String {
        self.rawValue.uppercased()
    }
    
    private enum CodingKeys: String, CodingKey {
        case flag
        case category
        case memo
    }
}


extension BadCategory: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        guard let value = BadCategory(rawValue: rawValue.lowercased()) else {
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
