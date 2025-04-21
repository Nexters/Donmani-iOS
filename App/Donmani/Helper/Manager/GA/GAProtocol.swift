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
    func send(parameters: [GA.Parameter: Any]?)
}

extension GAProtocol {
    func send(parameters: [GA.Parameter: Any]? = nil) {
        var convertKeyValue: [String: Any]? = [:]
        if let screen {
            convertKeyValue?["screen_name"] = screen.rawValue
        }
        
        parameters?.forEach {
            convertKeyValue?[$0.key.value] = $0.value
        }
        
        if convertKeyValue?.isEmpty ?? true {
            convertKeyValue = nil
        }
        
        Analytics.logEvent(
            eventName,
            parameters: convertKeyValue
        )
    }
}

