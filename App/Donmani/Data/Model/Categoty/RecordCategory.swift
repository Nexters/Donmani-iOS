//
//  RecordCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import Foundation

struct RecordCategory: CategoryProtocol {    
    private let _isEqual: (Any) -> Bool
    private let _hashValue: () -> Int
    private let _title: () -> String
    private let _instance: any CategoryProtocol

    var title: String {
        _title()
    }

    init<T: CategoryProtocol>(_ instance: T) {
        _title = { instance.title }
        _isEqual = { ($0 as? T) == instance }
        _hashValue = { instance.hashValue }
        _instance = instance
    }
    
    func getInstance<T: CategoryProtocol>() -> T? {
        _instance as? T
    }

    static func == (lhs: RecordCategory, rhs: RecordCategory) -> Bool {
        lhs._isEqual(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue())
    }
}
