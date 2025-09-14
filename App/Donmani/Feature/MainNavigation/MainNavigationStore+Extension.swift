//
//  MainNavigationStore+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture
import StoreKit
import UIKit

extension MainNavigationStore {
    func requestAppStoreReview() async {
        if HistoryStateManager.shared.isReadyToRequestAppReview() {
            let connectedScenes = await UIApplication.shared.connectedScenes
            if let windowScene = connectedScenes.map({$0}).first as? UIWindowScene {
                await AppStore.requestReview(in: windowScene)
                HistoryStateManager.shared.setCompleteRequestAppReview()
            }
        }
    }
    
    func convertDecorationData(rewards: [Reward]) -> DecorationData {
        let items: [RewardItemCategory: Reward] = rewards.reduce(into: [:]) { result, item in
            result[item.category] = item
        }
        let backgroundRewardData: Data? = items[.background].map { try? fileRepository.loadRewardData(from: $0, resourceType: .image) }
        let effectRewardData: Data? = items[.effect].map { try? fileRepository.loadRewardData(from: $0, resourceType: .json) }
        let decorationRewardName: String? = items[.decoration].map { RewardResourceMapper(id: $0.id, category: .decoration).resource() }
        let decorationRewardId: Int? = items[.decoration]?.id
        let bottleRewardId: Int? = items[.bottle].map { $0.id }
        let bottleShape: BottleShape = bottleRewardId.map { BottleShape(id: $0) } ?? .default
        return DecorationData(
            backgroundRewardData: backgroundRewardData,
            effectRewardData: effectRewardData,
            decorationRewardName: decorationRewardName,
            decorationRewardId: decorationRewardId,
            bottleRewardId: bottleRewardId,
            bottleShape: bottleShape
        )
    }
}
