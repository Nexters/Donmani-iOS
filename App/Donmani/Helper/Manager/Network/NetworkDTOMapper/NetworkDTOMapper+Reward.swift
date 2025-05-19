//
//  NetworkDTOMapper+Reward.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import DNetwork

extension NetworkDTOMapper {
    static func mapper(dto: FeedbackCardDTO) -> FeedbackCard {
        var category = mapper(type: .good, rawValue: dto.category)
        if (category == nil) {
            category = mapper(type: .bad, rawValue: dto.category)
        }
        return FeedbackCard(
            category: category!,
            title: dto.title,
            content: dto.content
        )
    }
    
    static func mapper(dto: FeedbackInfoDTO) -> FeedbackInfo {
        return FeedbackInfo(
            isNotOpened: dto.isNotOpened,
            isFirstOpened: dto.isFirstOpened,
            totalCount: dto.totalCount
        )
    }
    
    static func mapper(dto: RewardDTO) -> [RewardItemCategory: [RewardItem]] {
        var result: [RewardItemCategory: [RewardItem]] = [:]
        dto.item.forEach { itemDTO in
            let category = mapper(rewardItemCategory: itemDTO.category)
            let rewardItem = RewardItem(
                id: itemDTO.id,
                name: itemDTO.name,
                imageUrl: itemDTO.imageUrl,
                soundUrl: itemDTO.soundUrl,
                category: category,
                owned: itemDTO.owned
            )
            result[category, default: []].append(rewardItem)
        }
        return result
    }
    
    static func mapper(rewardItemCategory: String) -> RewardItemCategory {
        for item in RewardItemCategory.allCases {
            if (item.rawValue.uppercased() == rewardItemCategory) {
                return item
            }
        }
        return .background
    }
}
