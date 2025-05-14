//
//  RecordCountSummary.swift
//  Donmani
//
//  Created by 문종식 on 4/17/25.
//

struct RecordCountSummary {
    let year: Int
    let monthlyRecords: [Int: RecordCountSummary.Month]
    
    struct Month {
        public let recordCount: Int
        public let totalDaysInMonth: Int
    }
}


