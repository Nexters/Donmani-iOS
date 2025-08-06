//
//  UserRewardItemResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import DNetwork

extension UserRewardItemResponse {
    func toDomain() -> [RewardItemCategory: [Reward]] {
        Dictionary<RewardItemCategory, [Reward]>(
            uniqueKeysWithValues: self.map { (key, value) in
                (RewardItemCategory(rawValue: key), value.map { $0.toDomain() })
            }
        )
    }
}
