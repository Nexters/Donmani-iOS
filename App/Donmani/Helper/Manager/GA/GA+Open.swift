//
//  GA+Open.swift
//  Donmani
//
//  Created by 문종식 on 4/13/25.
//

extension GA {
    struct Open: GAProtocol {
        enum Event {
            case notificationOpen
        }
        
        let event: Event
        var eventName: String {
            var value = "O_"
            switch event {
            case .notificationOpen:
                value += "notification_open"
            }
            return value
        }
        
        var screen: GA.Screen? {
            switch event {
            case .notificationOpen:
                return nil
            }
        }
        
        init(event: Event) {
            self.event = event
        }
    }
}
