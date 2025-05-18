//
//  RewardDTO.swift
//  DNetwork
//
//  Created by 문종식 on 5/18/25.
//

public struct RewardDTO: Decodable {
    public let category: String?
    public let item: [RewardItemDTO]
}
