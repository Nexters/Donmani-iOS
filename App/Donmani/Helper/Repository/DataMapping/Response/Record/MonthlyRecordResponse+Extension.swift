//
//  MonthlyRecordResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

import DNetwork

extension MonthlyRecordResponse {
    func toDomain() -> MonthlyRecordState {
        MonthlyRecordState(
            records: self.records?.map { $0.toDomain() },
            saveItems: self.saveItems.map { $0.toDomain() },
            hasNotOpenedRewards: self.hasNotOpenedRewards,
            totalExpensesCount: self.totalExpensesCount
        )
    }
}
