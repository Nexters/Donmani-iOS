//
//  GA+Receive.swift
//  Donmani
//
//  Created by 문종식 on 4/13/25.
//

extension GA {
    struct Receive: GAProtocol {
        enum Event {
            case notificationReceive
        }
        
        let event: Event
        var eventName: String {
            var value = "[R]"
            switch event {
            case .notificationReceive:
                value += "notification_receive"
            }
            return value
        }
        
        var screen: GA.Screen? {
            switch event {
            case .notificationReceive:
                return nil
            }
        }
        
        init(event: Event) {
            self.event = event
        }
    }
}
