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
            categoryCounts: self.categoryCounts.reduce(
                into: [RecordCategory: Int]()
            ) { result, item in
                let category = RecordCategory(rawValue: item.key.lowercased()) ?? .none
                result[category] = item.value
            }
        )
    }
}
