//
//  RewardItemDTO.swift
//  DNetwork
//
//  Created by 문종식 on 5/18/25.
//

public struct RewardItemDTO: Decodable {
    public let id: Int
    public let name: String
    public let imageUrl: String?
    public let jsonUrl: String?
    public let mp3Url: String?
    public let thumbnailUrl: String?
    public let category: String
    public let newAcquiredFlag: Bool
    public let hidden: Bool
    public let hiddenRead: Bool
}
