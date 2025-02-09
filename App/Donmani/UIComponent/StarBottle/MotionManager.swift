//
//  MotionManager.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

import CoreMotion

final class MotionManager {
    static let motion: CMMotionManager = CMMotionManager()
    static var timer: Timer?
    
    static func startGyros(handler: @escaping (Double, Double) -> Void) {
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 50.0
            self.motion.startGyroUpdates()
            self.timer = Timer(
                fire: Date(),
                interval: (1.0/50.0),
                repeats: true
            ) { (timer) in
                self.motion.startDeviceMotionUpdates(
                    using: .xArbitraryZVertical,
                    to: .main
                ) { deviceMotion, error in
                    guard let deviceMotion = deviceMotion else { return }
                    handler(deviceMotion.attitude.roll, deviceMotion.attitude.pitch)
                }
            }
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }
    
    static func stopGyros() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            self.motion.stopGyroUpdates()
        }
    }
}
