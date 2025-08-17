//
//  LoadRewardUseCase.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import ComposableArchitecture

protocol LoadRewardUseCase {
    func loadTodayDecorationItems() -> [RewardItemCategory: Reward]
    func loadDecorationItems(day: Day) -> [RewardItemCategory: Reward]
}

struct DefaultLoadRewardUseCase: LoadRewardUseCase {
    private var rewardRepository: RewardRepository
    
    init(rewardRepository: RewardRepository) {
        self.rewardRepository = rewardRepository
    }
    
    func loadTodayDecorationItems() -> [RewardItemCategory: Reward] {
        let today: Day = .today
        return rewardRepository.loadEquippedItems(year: today.year, month: today.month)
    }
    
    func loadDecorationItems(day: Day) -> [RewardItemCategory: Reward] {
        rewardRepository.loadEquippedItems(year: day.year, month: day.month)
    }
}

extension DependencyValues {
    private enum LoadRewardUseCaseKey: DependencyKey {
        static let liveValue: LoadRewardUseCase = {
            @Dependency(\.rewardRepository) var rewardRepository
            return DefaultLoadRewardUseCase(
                rewardRepository: rewardRepository
            )
        }()
    }
    
    var loadRewardUseCase: LoadRewardUseCase {
        get { self[LoadRewardUseCaseKey.self] }
        set { self[LoadRewardUseCaseKey.self] = newValue }
    }
}
