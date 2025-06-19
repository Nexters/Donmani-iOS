//
//  RewardInventoryDTO.swift
//  DNetwork
//
//  Created by 문종식 on 5/18/25.
//

public struct RewardInventoryDTO: Decodable {
//    public let BGM : [RewardItemDTO]
    public let CASE : [RewardItemDTO]
    public let EFFECT : [RewardItemDTO]
    public let BACKGROUND : [RewardItemDTO]
    public let DECORATION : [RewardItemDTO]
}
