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
            var value = "V_"
            switch event {
                //            case .main:
                //                value += "main"
                //            case .recordmain:
                //                value += "recordmain"
            case .recordmainBackBottomsheet:
                return value + "recordmain_back_bottomsheet"
                //            case .confirm:
                //                value += "confirm"
                //            case .recordhistory:
                //                value += "recordhistory"
                //            case .insight:
                //                value += "insight"
                //            case .customize:
                //                value += "customize"
                //            }
                //            return value
            default:
                return AnalyticsEventScreenView
            }
        }
        
        var screen: GA.Screen? {
            switch event {
            case .onboarding:
                return .onboarding
            case .main:
                return .main
            case .setting:
                return .setting
            case .recordmain:
                return .recordmain
            case .recordmainBackBottomsheet:
                return .recordmain
            case .confirm:
                return .confirm
            case .record:
                return .record
            case .recordhistory:
                return .recordhistory
            case .insight:
                return .insight
            case .reward:
                return .reward
            case .received:
                return .received
            case .feedback:
                return .feedback
            case .customize:
                return .customize
            }
        }
        
        var event: Event
        
        init(event: Event) {
            self.event = event
        }
    }
}
