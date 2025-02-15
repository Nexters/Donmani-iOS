//
//  RecordDAO.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import ComposableArchitecture

final class RecordDAO: DependencyKey {
    static var liveValue: RecordDAO = RecordDAO()
    
    static func insert() {
        
    }
    
    static func select() {
        
    }
//    func udpate() {
//        
//    }
    
//    func delete() {
//        
//    }
}

extension DependencyValues {
    var recordDAO: RecordDAO {
        get {
            self[RecordDAO.self]
        } set {
            self[RecordDAO.self] = newValue
        }
    }
}
