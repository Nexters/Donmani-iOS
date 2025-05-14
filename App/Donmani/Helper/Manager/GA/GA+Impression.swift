//
//  GA+Impression.swift
//  Donmani
//
//  Created by 문종식 on 4/13/25.
//

extension GA {
    struct Impression: GAProtocol {
        enum Event {
            case recordhistory
            case insight
        }
        
        let event: Event
        var eventName: String {
            var value = "I_"
            switch event {
            case .recordhistory:
                value += "recordhistory"
            case .insight:
                value += "insight"
            }
            return value
        }
        
        var screen: GA.Screen? {
            switch event {
            case .recordhistory:
                return .recordhistory
            case .insight:
                return .insight
            }
        }
        
        init(event: Event) {
            self.event = event
        }
    }
}
