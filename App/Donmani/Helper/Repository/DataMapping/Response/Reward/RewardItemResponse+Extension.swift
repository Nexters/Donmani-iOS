//
//  RewardItemResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import DNetwork

extension RewardItemResponse {
    func toDomain() -> Reward {
        Reward(
            id: self.id,
            name: self.name,
            imageUrl: self.imageUrl,
            jsonUrl: self.jsonUrl,
            soundUrl: self.mp3Url,
            thumbnailUrl: self.thumbnailUrl,
            category: RewardItemCategory(rawValue: self.category),
            newAcquiredFlag: self.newAcquiredFlag,
            hidden: self.hidden,
            hiddenRead: self.hiddenRead,
            resourceType: {
                if self.imageUrl.isSome { return .image }
                if self.jsonUrl.isSome { return .json }
                if self.mp3Url.isSome { return .mp3 }
                return .image
            }()
        )
    }
}
