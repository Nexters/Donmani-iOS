//
//  Category.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import Foundation

struct Category: Equatable {
    private let base: any CategoryProtocol
    
    init<T: CategoryProtocol>(_ base: T) {
        self.base = base
    }
    
    public var rawValue: AnyHashable {
        return base.rawValue as? String
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.base.rawValue as? String == rhs.base.rawValue as? String
    }
}
