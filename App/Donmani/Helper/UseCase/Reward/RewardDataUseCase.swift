//
//  RewardDataUseCase.swift
//  Donmani
//
//  Created by 문종식 on 8/16/25.
//

import Foundation
import ComposableArchitecture

protocol RewardDataUseCase {
    func loadData(from reward: Reward) -> Data
}

struct DefaultRewardDataUseCase: RewardDataUseCase {
    private var rewardRepository: RewardRepository
    private var fileRepository: FileRepository
    
    init(
        rewardRepository: RewardRepository,
        fileRepository: FileRepository
    ) {
        self.rewardRepository = rewardRepository
        self.fileRepository = fileRepository
    }
    
    func loadData(from reward: Reward) -> Data {
        (try? fileRepository.loadRewardData(
            from: reward,
            resourceType: reward.resourceType
        )) ?? Data()
    }
}

extension DependencyValues {
    private enum RewardDataUseCaseKey: DependencyKey {
        static let liveValue: RewardDataUseCase = {
            @Dependency(\.rewardRepository) var rewardRepository
            @Dependency(\.fileRepository) var fileRepository
            return DefaultRewardDataUseCase(
                rewardRepository: rewardRepository,
                fileRepository: fileRepository
            )
        }()
    }
    
    var rewardDataUseCase: RewardDataUseCase {
        get { self[RewardDataUseCaseKey.self] }
        set { self[RewardDataUseCaseKey.self] = newValue }
    }
}
