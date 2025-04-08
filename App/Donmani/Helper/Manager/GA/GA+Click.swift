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
            switch event {
            case .onboardingStartButton:
                return "onboarding_start_button"
            case .onboardingRecordButton:
                return "onboarding_record_button"
            case .onboardingHomeButton:
                return "onboarding_home_button"
            case .mainRecordButton:
                return "mainR_record_button"
            case .mainRecordArchiveButton:
                return "main_record_archive_button"
            case .mainSettingButton:
                return "main_setting_button"
            case .recordhistoryRecordButton:
                return "recordhistory_record_button"
            case .listButton:
                return "list_button"
            case .list별통이Button:
                return "list_별통이_button"
            case .insightButton:
                return "insight_button"
            case .recordmainYesterdayButton:
                return "recordmain_yesterday_button"
            case .recordmainTodayButton:
                return "recordmain_today_button"
            case .recordmainGoodButton:
                return "recordmain_good_button"
            case .recordmainBadButton:
                return "recordmain_bad_button"
            case .recordmainEmptyButton:
                return "recordmain_empty_button"
            case .recordmainSubmitButton:
                return "recordmain_submit_button"
            case .recordmainEmptyYesButton:
                return "recordmain_empty_yes_button"
            case .recordmainEmptyNoButton:
                return "recordmain_empty_no_button"
            case .recordmainBackButton:
                return "recordmain_back_button"
            case .recordBackButton:
                return "record_back_button"
            case .recordContinueButton:
                return "record_continue_button"
            case .recordNexttimeButton:
                return "record_nexttime_button"
            case .recordCloseButton:
                return "record_close_button"
            case .confirmBackButton:
                return "confirm_back_button"
            case .confirmSubmitButton:
                return "confirm_submit_button"
            case .settingNickname:
                return "setting_nickname"
            case .settingApppush:
                return "setting_apppush"
            case .settingNotice:
                return "setting_notice"
            case .settingRules:
                return "setting_rules"
            }
        }

        var event: Event
        init(event: Event) {
            self.event = event
        }
    }
}
