//
//  Day.swift
//  Donmani
//
//  Created by 문종식 on 4/3/25.
//

import Foundation

struct Day {
    let year: Int
    let month: Int
    let day: Int
    
    init(
        year: Int = 0,
        month: Int = 0,
        day: Int = 0
    ) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(yyyymmdd: String) {
        let split = yyyymmdd.components(separatedBy: "-").map(Int.init)
        self.day = split[2] ?? 1
        self.month = split[1] ?? 1
        self.year = split[0] ?? 1
    }
    
    init(yymmdd: String) {
        let split = yymmdd.components(separatedBy: "-").map(Int.init)
        self.day = split[2] ?? 1
        self.month = split[1] ?? 1
        self.year = (split[0] ?? 0) + 2000
    }
    
    init(day: Int, month: Int) {
        self.day = day
        self.month = month
        self.year = 2025
    }
    
    var yyyyMMdd: String {
        "\(year)-\(month.twoDigitString)-\(day.twoDigitString)"
    }
}

extension Day: Equatable, Comparable {
    static func < (lhs: Day, rhs: Day) -> Bool {
        if lhs.year < lhs.year { return true }
        if lhs.month < lhs.month { return true }
        if lhs.day < lhs.day { return true }
        return false
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        if lhs.year != lhs.year { return false }
        if lhs.month != lhs.month { return false }
        if lhs.day != lhs.day { return false }
        return true
    }
}

// Static
extension Day {
    static var today: Day {
        let components = todayComponents
        return Day(
            year: components.year ?? 0,
            month: components.month ?? 0,
            day: components.day ?? 0
        )
    }
    
    static var yesterDay: Day {
        let components = yesterdayComponents
        return Day(
            year: components.year ?? 0,
            month: components.month ?? 0,
            day: components.day ?? 0
        )
    }
    
    
    
    private static var todayComponents: DateComponents {
        Calendar.current.dateComponents([.day, .month, .year], from: Date())
    }
    
    private static var yesterdayComponents: DateComponents {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return Calendar.current.dateComponents([.day, .month, .year], from: yesterday ?? Date())
    }
}
