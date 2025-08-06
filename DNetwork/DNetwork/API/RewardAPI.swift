//
//  RewardAPI.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct RewardAPI {
    private let request = NetworkRequest()
    
    public init() { }
    
    /// 사용자의 리워드 아이템 조회
    public func getUserRewardItem(userKey: String) async throws -> UserRewardItemResponse {
        let result: DResponse<UserRewardItemResponse> = try await request.get(
            path: .reward,
            addtionalPaths: ["edit", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 열지 않은 리워드 개수 조회
    public func getNotOpenRewardCount(userKey: String) async throws -> Int {
        let result: DResponse<Int> = try await request.get(
            path: .reward,
            addtionalPaths: ["not-open", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 월별 착용아이템 조회
    public func getMonthlyRewardItem(userKey: String, year: Int, month: Int) async throws -> [RewardItemResponse] {
        let result: DResponse<[RewardItemResponse]> = try await request.get(
            path: .reward,
            addtionalPaths: [userKey],
            parameters: [
                "year": year,
                "month": month
            ]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 히든 아이템 확인 여부 업데이트
    public func putHiddenRead(userKey: String, year: Int, month: Int) async throws {
        let _: EmptyResponse = try await request.put(
            path: .reward,
            addtionalPaths: ["hidden-read"],
            bodyData: HiddenReadRequest(
                userKey: userKey,
                year: year,
                month: month
            )
        )
    }
    
    /// 리워드 아이템 오픈
    public func putOpenReward(userKey: String) async throws -> [RewardItemResponse] {
        let result: DResponse<[RewardItemResponse]> = try await request.put(
            path: .reward,
            addtionalPaths: ["open", userKey],
            bodyData: EmptyRequest()
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 월별 리워드 아이템 저장
    public func putSaveReward(
        bodyData: RewardSaveRequest
//        userKey: String,
//        year: Int,
//        month: Int,
//        backgroundId: Int,
//        effectId: Int,
//        decorationId: Int,
//        byeoltongCaseId: Int
    ) async throws {
        let _: EmptyResponse = try await request.put(
            path: .reward,
            bodyData: bodyData
        )
    }
}
