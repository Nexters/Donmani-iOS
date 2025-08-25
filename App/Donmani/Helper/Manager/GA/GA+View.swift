//
//  GA+View.swift
//  Donmani
//
//  Created by 문종식 on 4/8/25.
//

import FirebaseAnalytics

extension GA {
    struct View: GAProtocol {
        enum Event: String {
            case onboarding
            
            // Main
            case main
            case setting
            
            // RecordEntry
            case recordmain
            case recordmainBackBottomsheet
            
            // RecordEntry - Save Confirm
            case confirm
            
            case record
            
            // RecordList
            case recordhistory

            // Statistics
            case insight
            
            case reward
            case received
            case feedback
            case customize
        }
        
        var eventName: String {
            switch event {
            case .recordmainBackBottomsheet:
                return "V_recordmain_back_bottomsheet"
            default:
                return AnalyticsEventScreenView
            }
        }
        
        var screen: GA.Screen? {
            switch event {
            case .onboarding:                   .onboarding
            case .main:                         .main
            case .setting:                      .setting
            case .recordmain:                   .recordmain
            case .recordmainBackBottomsheet:    .recordmain
            case .confirm:                      .confirm
            case .record:                       .record
            case .recordhistory:                .recordhistory
            case .insight:                      .insight
            case .reward:                       .reward
            case .received:                     .received
            case .feedback:                     .feedback
            case .customize:                    .customize
            }
        }
        
        var event: Event
        
        init(event: Event) {
            self.event = event
        }
    }
}
