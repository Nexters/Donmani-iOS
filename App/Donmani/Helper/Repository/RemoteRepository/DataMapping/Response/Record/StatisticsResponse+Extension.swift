//
//  StatisticsResponse+Extension.swift
//  Donmani
//
//  Created by Gabia on 7/30/25.
//

import DNetwork

extension StatisticsResponse {
    func toDomain() -> RecordStatistics {
        RecordStatistics(
            year: self.year,
            month: self.month,
            goodCount: self.goodCount,
            badCount: self.badCount,
            hasRecords: self.hasRecords,
            records: self.records?.map { $0.toDomain() }
        )
    }
}
