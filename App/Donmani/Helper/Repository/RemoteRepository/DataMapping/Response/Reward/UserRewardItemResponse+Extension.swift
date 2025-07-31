//
//  UserRewardItemResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import DNetwork

extension UserRewardItemResponse {
    func toDomain() -> [RewardItemCategory: [Reward]] {
        var result: [RewardItemCategory: [Reward]] = [:]
        for (key, value) in self {
            result[RewardItemCategory(rawValue: key)] = value.map { $0.toDomain() }
        }
        return result
    }
}
