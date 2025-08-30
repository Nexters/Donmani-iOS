//
//  SummaryResponse.swift
//  Donmani
//
//  Created by 문종식 on 8/17/25.
//

import DNetwork

extension SummaryResponse {
    func toDomain() -> RecordCountSummary {
        RecordCountSummary(
            year: self.year,
            monthlyRecords: self.monthlyRecords.reduce(
                into: [Int: RecordCountSummary.Month]()
            ) { result, element in
                guard let month = Int(element.key) else { return }
                result[month] = RecordCountSummary.Month(
                    recordCount: element.value.recordCount,
                    totalDaysInMonth: element.value.totalDaysInMonth
                )
            }
        )
    }
}
