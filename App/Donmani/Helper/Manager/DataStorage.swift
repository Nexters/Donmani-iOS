//
//  DataStorage.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

class DataStorage {
    private static let shared = DataStorage()
    
    var inventory: [RewardItemCategory: [Reward]] = [:]
    var userName = ""
    var recordData: [String: [Record]] = [:]
    
    
    
    private init() {
        
    }
    
    static func setInventory(_ item: [RewardItemCategory: [Reward]]) {
        shared.inventory = item
    }
    
    static func getInventory() -> [RewardItemCategory: [Reward]] {
        shared.inventory
    }
    
    
    static func getUserName() -> String {
        shared.userName
    }
    
    static func setUserName(_ name: String) {
        shared.userName = name
    }
    
    /// yyyy-MM 형식
    static func getRecord(yearMonth: String) -> [Record]? {
        shared.recordData[yearMonth]
    }
    
    /// yyyy-MM 형식
    static func setRecord(_ record: Record) {
        let YMD = record.date.components(separatedBy: "-")
        shared.recordData["\(YMD[0])-\(YMD[1])", default: []].append(record)
    }
    
    static func setMonthRecords(year: Int, month: Int, _ records: [Record]) {
        let key = "\(year)-\(String(format: "%02d", month))"
        shared.recordData[key] = records
    }
}
