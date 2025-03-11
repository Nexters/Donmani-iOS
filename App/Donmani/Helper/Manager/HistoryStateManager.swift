//
//  HistoryStateManager.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

final class HistoryStateManager {
    static let shared = HistoryStateManager()
    
    private let userDefaults = UserDefaults.standard
    private let isFirstRecordKey = "IS_FIRST_RECORD"
    private let guideShownKey = "GUIDE_SHOWN"
    private let lastRecordKey = "LAST_RECORD"
    private let secondToLastRecordKey = "SECOND_TO_LAST_RECORD"
    private let emptyRecordGuideKey = "EMPTY_RECORD_GUIDE"
    
    private init() {}
    
    func getGuideState() -> String? {
        userDefaults.string(forKey: guideShownKey)
    }
    
    func setGuideState() {
        userDefaults.set(guideShownKey, forKey: guideShownKey)
    }
    
    func getEmptyRecordGuideKey() -> Bool {
        return userDefaults.string(forKey: emptyRecordGuideKey) != nil
    }
    
    func setEmptyRecordGuideKey() {
        userDefaults.set(emptyRecordGuideKey, forKey: emptyRecordGuideKey)
    }
    
    func getIsFirstRecord() -> String? {
        userDefaults.string(forKey: isFirstRecordKey)
    }
    
    func setIsFirstRecord() {
        userDefaults.set(isFirstRecordKey, forKey: isFirstRecordKey)
    }
    
    func addRecord(for type: DayType) {
        let newDateString = DateManager.shared.getFormattedDate(for: type)
        
        let lastRecord = userDefaults.string(forKey: lastRecordKey)
        let secondToLastRecord = userDefaults.string(forKey: secondToLastRecordKey)
        
        if let lastRecord = lastRecord {
            if newDateString > lastRecord {
                userDefaults.set(lastRecord, forKey: secondToLastRecordKey)
                userDefaults.set(newDateString, forKey: lastRecordKey)
            } else if (newDateString < lastRecord) && (newDateString > (secondToLastRecord ?? "")) {
                userDefaults.set(newDateString, forKey: secondToLastRecordKey)
            }
        } else {
            userDefaults.set(newDateString, forKey: lastRecordKey)
        }
    }
    
    func getRecords() -> (lastRecord: String?, secondToLastRecord: String?) {
        let lastRecord = userDefaults.string(forKey: lastRecordKey)
        let secondToLastRecord = userDefaults.string(forKey: secondToLastRecordKey)
        return (lastRecord, secondToLastRecord)
    }
    
    func getState() -> [DayType: Bool] {
        let todayString = DateManager.shared.getFormattedDate(for: .today)
        let yesterdayString = DateManager.shared.getFormattedDate(for: .yesterday)
        let records = getRecords()
        var state: [DayType: Bool] = [.today: false, .yesterday: false]
        
        if (records.lastRecord == todayString) || (records.secondToLastRecord == todayString) {
            state[.today] = true
        }
        
        if (records.lastRecord == yesterdayString) || (records.secondToLastRecord == yesterdayString) {
            state[.yesterday] = true
        }
        return state
    }
}

