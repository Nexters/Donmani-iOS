//
//  NetworkDTOMapper+Reward.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import DNetwork

//extension NetworkDTOMapper {
//    static func mapper(dto: FeedbackCardDTO) -> FeedbackCard {
//        let rawValue = dto.category.lowercased()
//        var category: RecordCategory? = nil
//        if rawValue != "none" {
//            category = mapper(type: .good, rawValue: rawValue)
//            if (category == nil) {
//                category = mapper(type: .bad, rawValue: rawValue)
//            }
//        }
//        return FeedbackCard(
//            category: category,
//            title: dto.title,
//            content: dto.content,
//            prefix: dto.flagType ? "오늘은" : "요즘은"
//        )
//    }
//    
//    static func mapper(dto: FeedbackInfoDTO) -> FeedbackInfo {
//        return FeedbackInfo(
//            isNotOpened: dto.isNotOpened,
//            isFirstOpened: dto.isFirstOpen,
//            totalCount: dto.totalCount
//        )
//    }
//    
//    static func mapper(dto: RewardDTO) -> [RewardItemCategory: [Reward]] {
//        var result: [RewardItemCategory: [Reward]] = [:]
//        dto.item.forEach { itemDTO in
//            let category = mapper(rewardItemCategory: itemDTO.category)
//            let rewardItem = mapper(
//                dto: itemDTO,
//                rewardItemCategory: category
//            )
//            result[category, default: []].append(rewardItem)
//        }
//        return result
//    }
//    
//    static func mapper(
//        dto: RewardItemDTO,
//        rewardItemCategory: RewardItemCategory
//    ) -> Reward {
//        let rewardItem = Reward(
//            id: dto.id,
//            name: dto.name,
//            imageUrl: dto.imageUrl,
//            jsonUrl: dto.jsonUrl,
//            soundUrl: dto.mp3Url,
//            thumbnailUrl: dto.thumbnailUrl,
//            category: rewardItemCategory,
//            newAcquiredFlag: dto.newAcquiredFlag,
//            hidden: dto.hidden,
//            resourceType: .image
//        )
//        return rewardItem
//    }
//    
//    static func mapper(
//        dto: [RewardItemDTO]
//    ) -> [Reward] {
//        let rewardItemList = dto.map { item in
//            Reward(
//                id: item.id,
//                name: item.name,
//                imageUrl: item.imageUrl,
//                jsonUrl: item.jsonUrl,
//                soundUrl: item.mp3Url,
//                thumbnailUrl: item.thumbnailUrl,
//                category: RewardItemCategory(rawValue: item.category),
//                newAcquiredFlag: item.newAcquiredFlag,
//                hidden: item.hidden,
//                hiddenRead: item.hiddenRead,
//                resourceType: .image
//            )
//        }
//        return rewardItemList
//    }
//    
//    static func mapper(dto: RewardInventoryDTO) -> [RewardItemCategory: [Reward]] {
//        var result: [RewardItemCategory: [Reward]] = [:]
//        result[.background] = mapper(dto: dto.BACKGROUND)
//        result[.effect] = mapper(dto: dto.EFFECT)
//        result[.byeoltong] = mapper(dto: dto.CASE)
////        result[.sound] = mapper(dto: dto.BGM)
//        result[.decoration] = mapper(dto: dto.DECORATION)
//        return result
//    }
//    
//    static func mapper(rewardItemCategory: String) -> RewardItemCategory {
//        for item in RewardItemCategory.allCases {
//            if (item.rawValue.uppercased() == rewardItemCategory) {
//                return item
//            }
//        }
//        return .background
//    }
//}
