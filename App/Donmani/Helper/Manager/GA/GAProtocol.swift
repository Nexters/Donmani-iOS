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
//        Analytics.logEvent(
//            eventName,
//            parameters: convertKeyValue
//        )
    }
}

