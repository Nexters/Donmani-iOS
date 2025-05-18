//
//  DNetworkService+Record.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

public extension DNetworkService {
    struct DReward {
        let request: DNetworkRequest
        let userKey: String
        
        public init() {
            self.request = DNetworkRequest()
            self.userKey = DNetworkService.userKey
        }
        
        public func reqeustAcquireRewards(count: Int) async throws -> RewardDTO {
            let response: RewardDTO = try await self.request.post(
                path: .rewards,
                addtionalPath: ["acquire", userKey],
                bodyData: ["count": count]
            )
            return response
        }
        
        public func fetchRewardsInventory(count: Int) async throws -> RewardInventoryDTO {
            let response: RewardInventoryDTO = try await self.request.get(
                path: .rewards,
                addtionalPath: ["inventory", userKey]
            )
            return response
        }
    }
}
