//
//  CategoryStatisticsResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct CategoryStatisticsResponse: Decodable {
    public let year: Int
    public let month: Int
    public let categoryCounts: [String: Int]
}
