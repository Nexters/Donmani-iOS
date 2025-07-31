//
//  SummaryResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct SummaryResponse: Decodable {
    public let year: Int
    public let monthlyRecords: [Int: Self.MonthlyInfo]
    
    public struct MonthlyInfo: Decodable {
        public let recordCount: Int
        public let totalDaysInMonth: Int
    }
}
