//
//  RecordContentType.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

enum RecordContentType: String, Equatable, CaseIterable {
    case good = "GOOD"
    case bad = "BAD"
    
    var title: String {
        switch self {
        case .good:
            return "행복"
        case .bad:
            return "후회"
        }
    }
    
    var selectTitle: String {
        switch self {
        case .good:
            return "행복했"
        case .bad:
            return "후회됐"
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "GOOD":
            self = .good
        case "BAD":
            self = .bad
        default:
            self = .good
        }
    }
}
