//
//  UserDefaultsDataSource.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import ComposableArchitecture

@propertyWrapper
struct UserDefault<T> {
    private let key: SettingDataSource.Key
    private let defaultValue: T
    private let userDefaults: UserDefaults

    var wrappedValue: T {
        get { userDefaults.object(forKey: key.value) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key.value) }
    }

    init(
        key: SettingDataSource.Key,
        defaultValue: T,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

struct SettingDataSource {
    // rawValue를 직접 지정한 case는 민감 정보로 변경이 어려운 case입니다.
    enum Key: String {
        /// 온보딩 페이지 표시 여부: Bool
        case shouldShowOnboarding = "IS_SHOWN_ONBOARDING"
        
        /// APNs Token: String
        case APNsToken = "APNS_TOKEN"
        
        /// Firebase Messaging Token: String
        case firebaseToken = "FIREBASE_TOKEN"
        
        /// App Store 리뷰 요청 표시 여부: Bool
        case shouldShowAppStoreReviewRequest
        
        /// 마지막 기록 날짜(YYYY-MM-DD): String
        case lastRecordDay
        
        /// 마지막에서 두번째 기록 날짜(YYYY-MM-DD): String
        case secondToLastRecordDay
        
        /// 기록하기 페이지 내 무소비 툴팁 표시 여부: Bool
        case shouldShowEmptyRecordToopTip
        
        /// 별통이 달력 페이지 내 상단 배너 표시 여부: Bool
        case shouldShowBottleCalendarTopBanner
        
        /// Notification Permission 요청 여부: Bool
        case shouldShowRequestNotificationPermission
        
        /// 기록 리스트 페이지 내 별통이 달력 툴팁 표시 여부: Bool
        case shouldShowBottleCalendarToopTip
        
        /// 연속 기록 날짜 수: Int
        case streakSubmitCount
        
        /// 리워드 진입 페이지 내 이벤트 바텀시트 표시 여부: Bool
        case shouldShowRewardEventBottomSheet
        
        /// 꾸미기 페이지 내 안내 바텀 시트 표시 여부: Bool
        case shouldShowDecorationGuideBottomSheet
        
        /// 꾸미기 저장 완료 안내 Alert 표시 여부: Bool
        case shouldShowDecorationSaveAlert
        
        /// 새 별통이 오픈 안내 날짜(YYYY-MM-DD): String
        case lastNewBottleGuideDay
        
        // 메인 페이지 내 어제 기록 유도 툴팁 표시 여부 -> 다른 객체로 위임
        // private let shouldShowYesterdayRecordToopTip = "LAST_YESTERDAY_TOOP_TIP_DAY"
        
        // 메인 페이지 내 선물 받기 툴팁 표시 여부 -> 다른 객체로 위임
        // private let isPresentingRewardToolTipView = "PRESENTING_REWARD_TOOL_TIP_VIEW"
        
        // 꾸미기 페이지 내 히든 아이템 바텀시트 여부 -> 다른 객체로 위임
        // case shouldShowHiddenRewardBottmSheet
        
        var value: String {
            self.rawValue
        }
    }
    
    /// 온보딩 페이지 표시 여부: Bool
    @UserDefault(key: .shouldShowOnboarding, defaultValue: false)
    static var shouldShowOnboarding: Bool
    
    /// APNs Token: String
    @UserDefault(key: .APNsToken, defaultValue: "")
    static var APNsToken: String
    
    /// Firebase Messaging Token: String
    @UserDefault(key: .firebaseToken, defaultValue: "")
    static var firebaseToken: String
    
    /// App Store 리뷰 요청 표시 여부: Bool
    @UserDefault(key: .shouldShowAppStoreReviewRequest, defaultValue: true)
    static var shouldShowAppStoreReviewRequest: Bool
    
    /// 마지막 기록 날짜(YYYY-MM-DD): String
    @UserDefault(key: .lastRecordDay, defaultValue: "0000-00-00")
    static var lastRecordDay: String
    
    /// 마지막에서 두번째 기록 날짜(YYYY-MM-DD): String
    @UserDefault(key: .secondToLastRecordDay, defaultValue: "0000-00-00")
    static var secondToLastRecordDay: String
    
    /// 기록하기 페이지 내 무소비 툴팁 표시 여부: Bool
    @UserDefault(key: .shouldShowEmptyRecordToopTip, defaultValue: true)
    static var shouldShowEmptyRecordToopTip: Bool
    
    /// 별통이 달력 페이지 내 상단 배너 표시 여부: Bool
    @UserDefault(key: .shouldShowBottleCalendarTopBanner, defaultValue: true)
    static var shouldShowBottleCalendarTopBanner: Bool
    
    /// Notification Permission 요청 여부: Bool
    @UserDefault(key: .shouldShowRequestNotificationPermission, defaultValue: true)
    static var shouldShowRequestNotificationPermission: Bool
    
    /// 기록 리스트 페이지 내 별통이 달력 툴팁 표시 여부: Bool
    @UserDefault(key: .shouldShowBottleCalendarToopTip, defaultValue: true)
    static var shouldShowBottleCalendarToopTip: Bool
    
    /// 연속 기록 날짜 수: Int
    @UserDefault(key: .streakSubmitCount, defaultValue: 0)
    static var streakSubmitCount: Int
    
    /// 리워드 진입 페이지 내 이벤트 바텀시트 표시 여부: Bool
    @UserDefault(key: .shouldShowRewardEventBottomSheet, defaultValue: true)
    static var shouldShowRewardEventBottomSheet: Bool
    
    /// 꾸미기 페이지 내 안내 바텀 시트 표시 여부: Bool
    @UserDefault(key: .shouldShowDecorationGuideBottomSheet, defaultValue: true)
    static var shouldShowDecorationGuideBottomSheet: Bool
    
    /// 꾸미기 저장 완료 안내 Alert 표시 여부: Bool
    @UserDefault(key: .shouldShowDecorationSaveAlert, defaultValue: true)
    static var shouldShowDecorationSaveAlert: Bool
    
    /// 새 별통이 열림 안내 표시 날짜
    @UserDefault(key: .lastNewBottleGuideDay, defaultValue: "0000-00-00")
    static var lastNewBottleGuideDay: String
}

extension DependencyValues {
    private enum SettingKey: DependencyKey {
        static var liveValue: SettingDataSource.Type = SettingDataSource.self
    }
    
    var settings: SettingDataSource.Type {
        get { self[SettingKey.self] }
        set { self[SettingKey.self] = newValue }
    }
}
