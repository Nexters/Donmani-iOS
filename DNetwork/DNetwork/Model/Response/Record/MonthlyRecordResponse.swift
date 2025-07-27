//
//  MonthlyRecordResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct MonthlyRecordResponse: Decodable {
    public let userKey: String
    public let records: [RecordResponse]?
    public let saveItems: [RewardItemDTO]
    public let hasNotOpenedRewards: Bool
    public let totalExpensesCount: Int
}
