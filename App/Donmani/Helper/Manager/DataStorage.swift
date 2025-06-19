//
//  DataStorage.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import Foundation

class DataStorage {
    private static let shared = DataStorage()
    
    var inventory: [RewardItemCategory: [Reward]] = [:]
    var userName = ""
    var recordData: [String: [Record]] = [:]
    
    var decorationItem: [RewardItemCategory:Reward] = [:]
    var currentMonthSound: String = ""
    
    private init() {
        
    }
    
    static func setDecorationItem(_ item: [RewardItemCategory:Reward]) {
        shared.decorationItem = item
    }
    
    static func getDecorationItem() -> [RewardItemCategory:Reward] {

        return shared.decorationItem
    }
    
    static func setSoundFileName(_ name: String) {
        shared.currentMonthSound = name
    }
    
    static func getSoundFileName() -> String {
        return shared.currentMonthSound
    }
    
    static func setInventory(_ item: [RewardItemCategory: [Reward]]) {
        for (key, value) in item {
            // TODO: - Remove All Data
             shared.inventory[key] = value
//            shared.inventory[key] = Reward.previewAllData.filter{ $0.category == key }
            switch key {
            case .decoration, .effect, .sound:
                let itemCount = shared.inventory[key]?.count ?? 0
                if (itemCount < 2) {
                    shared.inventory[key] = []
                }
            default:
                break
            }
        }
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
    
    static func saveJsonFile(data: Data, name: String) throws {
        let fileManager = FileManager.default
        let fileName = "\(name).json"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }
        try data.write(to: destinationURL)
    }
    
    static func saveImageFile(data: Data, name: String) throws {
        let fileManager = FileManager.default
        let fileName = "\(name).png"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }
        try data.write(to: destinationURL)
    }
}
