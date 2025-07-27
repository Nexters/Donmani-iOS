//
//  CategoryCountDTO.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

public struct CategoryCountDTO: Decodable {
    public let year: Int
    public let month: Int
    public let categoryCounts: [String: Int]
}
