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
    private let isShownOnboarding = "IS_SHOWN_ONBOARDING"
    private let isFirstRecordKey = "IS_FIRST_RECORD"
    private let guideShownKey = "GUIDE_SHOWN"
    private let lastRecordKey = "LAST_RECORD"
    private let secondToLastRecordKey = "SECOND_TO_LAST_RECORD"
    private let emptyRecordGuideKey = "EMPTY_RECORD_GUIDE"
    private let isFirstDayOfMonth = "IS_FIRST_DAY_OF_MONTH"
    private let monthlyBottleGuide = "MONTHLY_BOTTLE_GUIDE"
    
    private let lastYesterdayToopTipDay =  "LAST_YESTERDAY_TOOP_TIP_DAY"
    
    // APNs Token
    private let apnsToken = "APNS_TOKEN"
    // Firebase Messaging Token
    private let firebaseToken = "FIREBASE_TOKEN"
    // Notification Permission
    private let requestNotificationPermission = "REQUSET_NOTIFICATION_PERMISSION"
    
    //
    private let isShownBottleListToopTip = "IS_SHOWN_BOTTLE_LIST_TOOP_TIP"
    
    // streak_submit
    private let streakSubmitCountKey = "STREAK_SUBMIT_COUNT"
    private let lastWriteRecordDateKey = "LAST_WRITE_RECORD_DATE"
    
    private init() {}
    
    func getLastWriteRecordDateKey() -> String {
        if let value = userDefaults.string(forKey: lastWriteRecordDateKey) {
            return value
        }
        return DateManager.shared.getFormattedDate(for: .yesterday)
    }
    
    func setLastWriteRecordDateKey() {
        let dateString = DateManager.shared.getFormattedDate(for: .today)
        userDefaults.set(dateString, forKey: lastWriteRecordDateKey)
    }
    
    func getStreakSubmitCountKey() -> Int {
        userDefaults.integer(forKey: streakSubmitCountKey)
    }
    
    func setStreakSubmitCountKey(count: Int) {
        userDefaults.set(count, forKey: streakSubmitCountKey)
    }

    func getLastYesterdayToopTipDay() -> String? {
        userDefaults.string(forKey: lastYesterdayToopTipDay)
    }
    func setLastYesterdayToopTipDay() {
        let dateString = DateManager.shared.getFormattedDate(for: .today)
        userDefaults.set(
            dateString,
            forKey: lastYesterdayToopTipDay
        )
    }
    
    func getIsShownBottleListToopTip() -> String? {
        userDefaults.string(forKey: isShownBottleListToopTip)
    }
    func setIsShownBottleListToopTip() {
        userDefaults.set(isShownBottleListToopTip, forKey: isShownBottleListToopTip)
    }
    
    func getRequestNotificationPermission() -> String? {
        userDefaults.string(forKey: requestNotificationPermission)
    }
    func setRequestNotificationPermission() {
        userDefaults.set(requestNotificationPermission, forKey: requestNotificationPermission)
    }
    
    func getAPNsToken() -> Bool {
        userDefaults.data(forKey: apnsToken) == nil
    }
    func setAPNsToken(token: Data) {
        userDefaults.set(token, forKey: apnsToken)
    }
    
    func getFirebaseToken() -> String? {
        userDefaults.string(forKey: firebaseToken)
    }
    func setFirebaseToken(token: String) {
        userDefaults.set(token, forKey: firebaseToken)
    }
    
    func getMonthlyBottleGuide() -> Bool {
        userDefaults.string(forKey: monthlyBottleGuide) == nil
    }
    
    func setMonthlyBottleGuide() {
        userDefaults.set(monthlyBottleGuide, forKey: monthlyBottleGuide)
    }
    
    func removeIsFirstDayOfMonth() {
        userDefaults.removeObject(forKey: isFirstDayOfMonth)
    }
    
    func getIsFirstDayOfMonth() -> Bool {
        userDefaults.string(forKey: isFirstDayOfMonth) == nil
    }
    
    func setIsFirstDayOfMonth() {
        userDefaults.set(isFirstDayOfMonth, forKey: isFirstDayOfMonth)
    }
    
    func getOnboardingState() -> Bool {
        userDefaults.string(forKey: isShownOnboarding) == nil
    }
    
    func setOnboardingState() {
        userDefaults.set(isShownOnboarding, forKey: isShownOnboarding)
    }
    
    func getGuideState() -> String? {
        userDefaults.string(forKey: guideShownKey)
    }
    
    func setGuideState() {
        userDefaults.set(guideShownKey, forKey: guideShownKey)
    }
    
    func getEmptyRecordGuideKey() -> Bool {
        return userDefaults.string(forKey: emptyRecordGuideKey) == nil
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

