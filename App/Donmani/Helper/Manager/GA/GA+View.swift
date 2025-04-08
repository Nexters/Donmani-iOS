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
        }
        
        var eventName: String {
            switch event {
            case .main:
                return "main"
            case .recordmain:
                return "recordmain"
            case .recordmainBackBottomsheet:
                return "recordmain_back_bottomsheet"
            case .confirm:
                return "confirm"
            case .recordhistory:
                return "recordhistory"
            case .insight:
                return "insight"
            }
        }
        
        var event: Event
        init(event: Event) {
            self.event = event
        }
    }
}
