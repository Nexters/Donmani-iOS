//
//  CategotyProtocol.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import Foundation

protocol CategoryProtocol: Hashable, Equatable {
    var title: String { get }
}

extension CategoryProtocol {
    public var hashValue: Int {
        title.hashValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
    }
}
