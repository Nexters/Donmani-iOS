//
//  FeedBackCardResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct FeedBackCardResponse: Decodable {
    public let category: String
    public let title: String
    public let name: String
    public let content: String
    public let flagType: Bool
}
