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
    
    static func mapper(dto: RewardDTO) -> [RewardItemCategory: [Reward]] {
        var result: [RewardItemCategory: [Reward]] = [:]
        dto.item.forEach { itemDTO in
            let category = mapper(rewardItemCategory: itemDTO.category)
            let rewardItem = mapper(
                dto: itemDTO,
                rewardItemCategory: category
            )
            result[category, default: []].append(rewardItem)
        }
        return result
    }
    
    static func mapper(
        dto: RewardItemDTO,
        rewardItemCategory: RewardItemCategory
    ) -> Reward {
        let rewardItem = Reward(
            id: dto.id,
            name: dto.name,
            imageUrl: dto.imageUrl,
            soundUrl: dto.soundUrl,
            category: rewardItemCategory,
            owned: dto.owned
        )
        return rewardItem
    }
    
    static func mapper(dto: RewardInventoryDTO) -> [RewardItemCategory: [Reward]] {
        var result: [RewardItemCategory: [Reward]] = [:]
        dto.forEach { rewardDTO in
            guard let categoryString = rewardDTO.category else {
                return
            }
            let category = mapper(rewardItemCategory: categoryString)
            rewardDTO.item.forEach { rewardItemDTO in
                let rewardItem = mapper(
                    dto: rewardItemDTO,
                    rewardItemCategory: category
                )
                result[category, default: []].append(rewardItem)
            }
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
