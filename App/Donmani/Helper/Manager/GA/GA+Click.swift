//
//  GA.swift
//  Donmani
//
//  Created by 문종식 on 4/6/25.
//

import FirebaseAnalytics

extension GA {
    struct Click: GAProtocol {
        enum Event {
            // Onboarding
            case onboardingStartButton
            case onboardingRecordButton
            case onboardingHomeButton
            
            // Main
            case mainRecordButton
            case mainRecordArchiveButton
            case mainSettingButton
            
            // RecordList
            case recordhistoryRecordButton
            case listButton
            case list별통이Button
            case insightButton
            
            // RecordEntry
            case recordmainYesterdayButton
            case recordmainTodayButton
            case recordmainGoodButton
            case recordmainBadButton
            case recordmainEmptyButton
            case recordmainSubmitButton
            case recordmainEmptyYesButton
            case recordmainEmptyNoButton
            case recordmainBackButton
            
            // RecordWriting
            case recordBackButton
            case recordContinueButton
            case recordNexttimeButton
            case recordCloseButton
            
            // RecordEntry - Save Confirm
            case confirmBackButton
            case confirmSubmitButton
            
            // Setting
            case settingNickname
            case settingApppush
            case settingNotice
            case settingRules
        }
        
        var eventName: String {
            var value = "[C]"
            switch event {
            case .onboardingStartButton:
                value += "onboarding_start_button"
            case .onboardingRecordButton:
                value += "onboarding_record_button"
            case .onboardingHomeButton:
                value += "onboarding_home_button"
            case .mainRecordButton:
                value += "mainR_record_button"
            case .mainRecordArchiveButton:
                value += "main_record_archive_button"
            case .mainSettingButton:
                value += "main_setting_button"
            case .recordhistoryRecordButton:
                value += "recordhistory_record_button"
            case .listButton:
                value += "list_button"
            case .list별통이Button:
                value += "list_별통이_button"
            case .insightButton:
                value += "insight_button"
            case .recordmainYesterdayButton:
                value += "recordmain_yesterday_button"
            case .recordmainTodayButton:
                value += "recordmain_today_button"
            case .recordmainGoodButton:
                value += "recordmain_good_button"
            case .recordmainBadButton:
                value += "recordmain_bad_button"
            case .recordmainEmptyButton:
                value += "recordmain_empty_button"
            case .recordmainSubmitButton:
                value += "recordmain_submit_button"
            case .recordmainEmptyYesButton:
                value += "recordmain_empty_yes_button"
            case .recordmainEmptyNoButton:
                value += "recordmain_empty_no_button"
            case .recordmainBackButton:
                value += "recordmain_back_button"
            case .recordBackButton:
                value += "record_back_button"
            case .recordContinueButton:
                value += "record_continue_button"
            case .recordNexttimeButton:
                value += "record_nexttime_button"
            case .recordCloseButton:
                value += "record_close_button"
            case .confirmBackButton:
                value += "confirm_back_button"
            case .confirmSubmitButton:
                value += "confirm_submit_button"
            case .settingNickname:
                value += "setting_nickname"
            case .settingApppush:
                value += "setting_apppush"
            case .settingNotice:
                value += "setting_notice"
            case .settingRules:
                value += "setting_rules"
            }
            return value
        }
        
        var screen: GA.Screen? {
            switch event {
            case .onboardingStartButton,
                    .onboardingRecordButton,
                    .onboardingHomeButton:
                return .onboarding
                
            case .mainRecordButton,
                    .mainRecordArchiveButton,
                    .mainSettingButton:
                return .main
                
            case .recordhistoryRecordButton,
                    .listButton,
                    .list별통이Button,
                    .insightButton:
                return .recordhistory
                
            case .recordmainYesterdayButton,
                    .recordmainTodayButton,
                    .recordmainGoodButton,
                    .recordmainBadButton,
                    .recordmainEmptyButton,
                    .recordmainSubmitButton,
                    .recordmainEmptyYesButton,
                    .recordmainEmptyNoButton,
                    .recordmainBackButton:
                return .recordmain
                
            case .recordBackButton,
                    .recordContinueButton,
                    .recordNexttimeButton,
                    .recordCloseButton:
                return .record
                
            case .confirmBackButton,
                    .confirmSubmitButton:
                return .confirm
                
            case .settingNickname,
                    .settingApppush,
                    .settingNotice,
                    .settingRules:
                return .setting
            }
        }
        
        var event: Event
        init(event: Event) {
            self.event = event
        }
    }
}
