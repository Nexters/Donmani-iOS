//
//  MonthlyRecordState.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

struct MonthlyRecordState {
    public let records: [NewRecord]?
    public let saveItems: [Reward]
    public let hasNotOpenedRewards: Bool
    public let totalExpensesCount: Int
    
    var decorationItem: [RewardItemCategory: Reward] {
        saveItems.reduce(into: [RewardItemCategory: Reward]()) { result, reward in
            result[reward.category] = reward
        }
    }
}
