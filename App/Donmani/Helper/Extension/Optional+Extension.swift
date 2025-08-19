//
//  Optional+Extension.swift
//  Donmani
//
//  Created by 문종식 on 8/6/25.
//

extension Optional {
    var isNil: Bool {
        switch self {
        case .none: true
        case .some(_): false
        }
    }
    
    var isSome: Bool {
        return !isNil
    }
    
    func map<T>(_ action: (Wrapped) -> T?) -> T? {
        if let value = self {
            return action(value)
        }
        return nil
    }
}
