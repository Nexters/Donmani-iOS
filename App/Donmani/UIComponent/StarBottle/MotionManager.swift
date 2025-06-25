//
//  MotionManager.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

import CoreMotion

final class MotionManager {
    let motion: CMMotionManager = CMMotionManager()
    var timer: Timer?
    var isRunning: Bool = false
    
    func startGyros(handler: @escaping (Double, Double) -> Void) {
        if motion.isGyroAvailable && !isRunning {
            self.isRunning = true
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
    
    func stopGyros() {
        self.isRunning = false
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            self.motion.stopGyroUpdates()
        }
    }
}
