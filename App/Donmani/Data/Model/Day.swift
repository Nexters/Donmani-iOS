//
//  Day.swift
//  Donmani
//
//  Created by 문종식 on 4/3/25.
//

struct Day {
    let day: Int
    let month: Int
    let year: Int
    
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
    
    static func >(lhs: Day, rhs: Day) -> Bool {
        if lhs.year > lhs.year {
            return true
        }
        if lhs.month > lhs.month {
            return true
        }
        if lhs.day > lhs.day {
            return true
        }
        return false
    }
    
    static func ==(lhs: Day, rhs: Day) -> Bool {
        let equalsYear = lhs.year == lhs.year
        let equalsMonth = lhs.month == lhs.month
        let equalsDay = lhs.day == lhs.day
        return equalsYear && equalsMonth && equalsDay
    }
}
