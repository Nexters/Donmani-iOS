//
//  TimeManager.swift
//  Donmani
//
//  Created by 문종식 on 2/12/25.
//

import Foundation

final class TimeManager {
    static private var timer: Timer?
    static private var remainingTimeInSeconds: Int = 0

    static private func calculateTimeRemaining() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let midnight = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60)
        let timeRemaining = Int(midnight.timeIntervalSince(now))
        return timeRemaining
    }
    
    static func start() {
        remainingTimeInSeconds = calculateTimeRemaining()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRemainingTime), userInfo: nil, repeats: true)
    }
    
    static func stop() {
        timer?.invalidate()
        timer = nil
    }

    @objc static private func updateRemainingTime() {
        if remainingTimeInSeconds > 0 {
            remainingTimeInSeconds -= 1
        } else {
            stop()
        }
    }

    static func getRemainingTime() -> Int {
        return calculateTimeRemaining()
    }
}
