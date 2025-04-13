//
//  GA+Submit.swift
//  Donmani
//
//  Created by 문종식 on 4/13/25.
//

extension GA {
    struct Submit: GAProtocol {
        enum Event {
            case streakSubmit
        }
        
        let event: Event
        var eventName: String {
            var value = "[S]"
            switch event {
            case .streakSubmit:
                value += "streak_submit"
            }
            return value
        }
        
        var screen: GA.Screen? {
            switch event {
            case .streakSubmit:
                return nil
            }
        }
        
        init(event: Event) {
            self.event = event
        }
    }
}
