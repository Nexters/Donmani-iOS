//
//  MonthlyRecordState.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

struct MonthlyRecordState {
    public let records: [Record]?
    public let saveItems: [Reward]
    public let hasNotOpenedRewards: Bool
    public let totalExpensesCount: Int
}
