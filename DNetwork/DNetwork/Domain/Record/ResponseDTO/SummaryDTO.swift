//
//  SummaryDTO.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

public struct SummaryDTO: Decodable {
    public let year: Int
    public let monthlyRecords: [Int: SummaryDTO.Month]
    
    public struct Month: Decodable {
        public let recordCount: Int
        public let totalDaysInMonth: Int
    }
}


