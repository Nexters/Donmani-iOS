//
//  StatisticsResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct StatisticsResponse: Decodable {
    public let year: Int
    public let month: Int
    public let goodCount: Int
    public let badCount: Int
    public let hasRecords: Bool
    public let records: [RecordResponse]?
}
