//
//  StatisticsDTO.swift
//  Donmani
//
//  Created by 문종식 on 4/15/25.
//

public struct StatisticsDTO: Decodable {
    public let year: Int
    public let month: Int
    public let goodCount: Int
    public let badCount: Int
    public let hasRecords: Bool
    public let records: [RecordResponseDTO.RecordDTO]?
}
