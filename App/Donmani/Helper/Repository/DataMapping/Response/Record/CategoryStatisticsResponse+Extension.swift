//
//  CategoryStatisticsResponse+Extension.swift
//  Donmani
//
//  Created by Gabia on 7/30/25.
//

import DNetwork

extension CategoryStatisticsResponse {
    func toDomain() -> CategoryStatistics {
        CategoryStatistics(
            year: self.year,
            month: self.month,
            categoryCounts: Dictionary(
                uniqueKeysWithValues:
                    self.categoryCounts.map { (key, value) in
                        (RecordCategory(rawValue: key), value)
                    }
            )
        )
    }
}
