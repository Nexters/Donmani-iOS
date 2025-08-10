//
//  HapticManager.swift
//  Donmani
//
//  Created by 문종식 on 4/2/25.
//

import CoreHaptics

struct HapticManager {
    static public let shared = HapticManager()
    
    private var engine: CHHapticEngine!
    private let supportsHaptics: Bool
    
    private init() {
        self.supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        if self.supportsHaptics {
            do {
                engine = try CHHapticEngine()
                engine.playsHapticsOnly = true
                try engine.start()
            } catch let error {
                fatalError("Engine Creation Error: \(error)")
            }
        }
    }
    
    public func playHapticTransient() {
        let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        if !supportsHaptics {
            return
        }
        
        let intensityParameter = CHHapticEventParameter(
            parameterID: .hapticIntensity,
            value: 0.4
        )
        
        let sharpnessParameter = CHHapticEventParameter(
            parameterID: .hapticSharpness,
            value: 0.4
        )
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParameter, sharpnessParameter],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error creating a haptic transient pattern: \(error)")
        }
    }
    
    deinit {
#if DEBUG
        print("\(#function) \(Self.self)")
#endif
    }
}
