//
//  GAProtocol.swift
//  Donmani
//
//  Created by 문종식 on 4/7/25.
//

import FirebaseAnalytics

protocol GAProtocol {
    var eventName: String { get }
    var screen: GA.Screen? { get }
    func send()
    func send(parameters: [GA.Parameter: Any])
}

extension GAProtocol {
    func send() {
//        Analytics.logEvent(eventName, parameters: nil)
    }
    
    func send(parameters: [GA.Parameter: Any]) {
//        var convertKeyValue: [String: Any] = [:]
//        parameters.forEach {
//            convertKeyValue[$0.key.value] = $0.value
//        }
//        if let screen {
//            convertKeyValue["screen_name"] = screen.rawValue
//        }
//        Analytics.logEvent(
//            eventName,
//            parameters: convertKeyValue
//        )
    }
}

