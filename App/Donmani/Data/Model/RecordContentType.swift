//
//  RecordContentType.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

enum RecordContentType: Codable, Equatable {
    case good
    case bad
    
    var title: String {
        switch self {
        case .good:
            return "좋은"
        case .bad:
            return "후회"
        }
    }
}
