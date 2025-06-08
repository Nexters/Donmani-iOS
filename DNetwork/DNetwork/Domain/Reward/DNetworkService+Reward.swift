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
        
        public func reqeustRewardOpen() async throws -> [RewardItemDTO] {
            let response: DResponse<[RewardItemDTO]> = try await self.request.put(
                path: .reward,
                addtionalPath: ["open", userKey],
                bodyData: Data()
            )
            return response.responseData ?? []
        }
        
        public func reqeustDecorationInfo(year: Int, month: Int) async throws -> [RewardItemDTO] {
            let response: DResponse<[RewardItemDTO]> = try await self.request.get(
                path: .reward,
                addtionalPath: [userKey],
                parameters: [
                    "year" : year,
                    "month" : month
                ]
            )
            guard let data = response.responseData else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func reqeustRewardItem() async throws -> RewardInventoryDTO {
            let response: DResponse<RewardInventoryDTO> = try await self.request.get(
                path: .reward,
                addtionalPath: ["edit", userKey]
            )
            guard let data = response.responseData else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func fetchRewardNotOpenCount() async throws -> Int {
            let response: DResponse<Int> = try await self.request.get(
                path: .reward,
                addtionalPath: ["not-open", userKey]
            )
            return response.responseData ?? 0
        }
        
        public func saveDecoration(dto: RewardSaveDTO) async throws {
            var dto = dto
            dto.userKey = userKey
            let _: DResponse<Data> = try await self.request.put(
                path: .reward,
                bodyData: dto
            )
        }
        
        public func requestHiddenRead() async throws {
            let _: DResponse<Data> = try await self.request.put(
                path: .reward,
                addtionalPath: ["hidden-read"],
                bodyData: Data()
            )
        }
    }
}
