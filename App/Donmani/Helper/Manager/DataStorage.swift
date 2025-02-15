//
//  DataStorage.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

class DataStorage {
    private static let shared = DataStorage()
    
    var userName = ""
    var recordData: [String: [Record]] = [:]
    
    private init() {
        
    }
    
    
    static func getUserName() -> String {
        shared.userName
    }
    
    static func setUserName(_ name: String) {
        shared.userName = name
    }
    
    static func getRecord(yearMonth: String) -> [Record]? {
        shared.recordData[yearMonth]
    }
    
    static func setRecord(_ record: Record) {
        let YMD = record.date.components(separatedBy: "-")
        shared.recordData["\(YMD[0])-\(YMD[1])", default: []].append(record)
    }
}
