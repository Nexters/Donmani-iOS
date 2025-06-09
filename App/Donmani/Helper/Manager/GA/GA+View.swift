//
//  GA+View.swift
//  Donmani
//
//  Created by 문종식 on 4/8/25.
//

extension GA {
    struct View: GAProtocol {
        enum Event: String {
            // Main
            case main
            // RecordEntry
            case recordmain
            case recordmainBackBottomsheet
            
            // RecordEntry - Save Confirm
            case confirm
            
            // RecordList
            case recordhistory

            // Statistics
            case insight
            
            case customize
        }
        
        var eventName: String {
            var value = "V_"
            switch event {
            case .main:
                value += "main"
            case .recordmain:
                value += "recordmain"
            case .recordmainBackBottomsheet:
                value += "recordmain_back_bottomsheet"
            case .confirm:
                value += "confirm"
            case .recordhistory:
                value += "recordhistory"
            case .insight:
                value += "insight"
            case .customize:
                value += "customize"
            }
            return value
        }
        
        var screen: GA.Screen? {
            switch event {
            case .main:
                return .main
            case .recordmain:
                return .recordmain
            case .recordmainBackBottomsheet:
                return .recordmain
            case .confirm:
                return .confirm
            case .recordhistory:
                return .recordhistory
            case .insight:
                return .insight
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
