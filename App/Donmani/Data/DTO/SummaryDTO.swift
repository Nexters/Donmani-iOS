//
//  SummaryDTO.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

struct SummaryDTO: Codable {
    let year: Int
    let monthlyRecords: [String: SummaryMonthly]
}

struct SummaryMonthly: Codable {
    let recordCount: Int
    let totalDaysInMonth: Int
}
