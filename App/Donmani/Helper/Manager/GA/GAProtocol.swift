//
//  GAProtocol.swift
//  Donmani
//
//  Created by 문종식 on 4/7/25.
//

import FirebaseAnalytics

protocol GAProtocol {
    var eventName: String { get }
    func send()
    func send(parameters: [String: Any]?)
}

extension GAProtocol {
    func send() {
//        Analytics.logEvent(eventName, parameters: nil)
    }
    
    func send(parameters: [String: Any]?) {
//        Analytics.logEvent(
//            eventName,
//            parameters: parameters
//        )
    }
}

