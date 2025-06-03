//
//  FeedbackCardDTO.swift
//  DNetwork
//
//  Created by 문종식 on 5/18/25.
//

public struct FeedbackCardDTO: Decodable {
    public let category: String
    public let title: String
    public let content: String
    public let flagType: Bool
}
