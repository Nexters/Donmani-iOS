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
    
    private let requestAppReviewStateKey = "REQUEST_APP_STORE_REVIEW_STATE"
    private let readyToRequestAppStoreReviewKey = "READY_TO_REQUEST_APP_STORE_REVIEW"
    private let completeRequestAppReviewKey = "COMPLETE_REQUEST_APP_STORE_REVIEW"
    
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
    private let isShownBottleCalendarToopTip = "IS_SHOWN_BOTTLE_LIST_TOOP_TIP"
    
    // streak_submit
    private let streakSubmitCountKey = "STREAK_SUBMIT_COUNT"
    private let lastWriteRecordDateKey = "LAST_WRITE_RECORD_DATE"
    
    // Reward
    private let isFirstRewardEnterKey = "FIRST_REWARD_ENTER"
    private let isFirstDecorationEnterKey = "FIRST_DECORATION_ENTER"
    private let isPresentingRewardToolTipView = "PRESENTING_REWARD_TOOL_TIP_VIEW"
    private let soundState = "SOUND_STATE"
    private let isShownFullRewardBottmSheet = "IS_SHOWN_FULL_REWARD_BOTTOM_SHEET"
    private let isFirstDecorationSave = "IS_FIRST_DECORATION_SAVE"
    
    private init() { }
    
    func setIsFirstDecorationSave() {
        userDefaults.set(isFirstDecorationSave, forKey: isFirstDecorationSave)
    }
    
    func getIsFirstDecorationSave() -> Bool {
        userDefaults.string(forKey: isFirstDecorationSave) == nil
    }
    
    func setIsShownFullRewardBottmeSheet() {
        userDefaults.set(isShownFullRewardBottmSheet, forKey: isShownFullRewardBottmSheet)
    }
    
    func getIsShownFullRewardBottmeSheet() -> Bool {
        userDefaults.string(forKey: isShownFullRewardBottmSheet) == nil
    }
    
    func setSouncState(_ flag: Bool) {
        userDefaults.set(flag, forKey: soundState)
    }
    
    func getSouncState() -> Bool {
        userDefaults.bool(forKey: soundState)
    }
    
    func setIsPresentingRewardToolTipView(_ flag: Bool) {
        if flag {
            userDefaults.removeObject(forKey: isPresentingRewardToolTipView)
        } else {
            userDefaults.set(isPresentingRewardToolTipView, forKey: isPresentingRewardToolTipView)
        }
    }
    
    func getIsPresentingRewardToolTipView() -> Bool {
        return userDefaults.string(forKey: isPresentingRewardToolTipView) != nil
    }
    
    func setIsFirstDecorationEnter() {
        userDefaults.set(isFirstDecorationEnterKey, forKey: isFirstDecorationEnterKey)
    }
    
    func getIsFirstDecorationEnter() -> Bool {
        return userDefaults.string(forKey: isFirstDecorationEnterKey) == nil
    }
    
    func setIsFirstRewardEnter() {
        userDefaults.set(isFirstRewardEnterKey, forKey: isFirstRewardEnterKey)
    }
    
    func getIsFirstRewardEnter() -> Bool {
        return userDefaults.string(forKey: isFirstRewardEnterKey) == nil
    }
    
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
    
    func getIsShownBottleCalendarToopTip() -> String? {
        userDefaults.string(forKey: isShownBottleCalendarToopTip)
    }
    func setIsShownBottleCalendarToopTip() {
        userDefaults.set(isShownBottleCalendarToopTip, forKey: isShownBottleCalendarToopTip)
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
    
    func getRequestAppReviewState() -> String? {
        userDefaults.string(forKey: requestAppReviewStateKey)
    }
    
    func setReadyToRequestAppReview() {
        userDefaults.set(readyToRequestAppStoreReviewKey, forKey: requestAppReviewStateKey)
    }
    
    func setCompleteRequestAppReview() {
        userDefaults.set(completeRequestAppReviewKey, forKey: requestAppReviewStateKey)
    }
    
    func isReadyToRequestAppReview() -> Bool {
        guard let state = getRequestAppReviewState() else {
            return false
        }
        return state == readyToRequestAppStoreReviewKey
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

