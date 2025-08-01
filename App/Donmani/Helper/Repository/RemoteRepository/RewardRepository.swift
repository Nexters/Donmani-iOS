//
//  RewardRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import DNetwork

final actor RewardRepository {
    let service: RewardService
    
    init(service: RewardService) {
        self.service = service
    }
    
    /// 사용자의 리워드 아이템 조회
    func getUserRewardItem(userKey: String) async throws -> [RewardItemCategory: [Reward]] {
        try await service.getUserRewardItem(userKey: userKey).toDomain()
    }
    
    /// 열지 않은 리워드 개수 조회
    func getNotOpenRewardCount(userKey: String) async throws -> Int {
        try await service.getNotOpenRewardCount(userKey: userKey)
    }
    
    /// 월별 착용아이템 조회
    func getMonthlyRewardItem(userKey: String, year: Int, month: Int) async throws -> [Reward] {
        try await service.getMonthlyRewardItem(
            userKey: userKey,
            year: year,
            month: month
        ).map { $0.toDomain() }
    }
    
    /// 히든 아이템 확인 여부 업데이트
    func putHiddenRead(userKey: String, year: Int, month: Int) async throws {
        try await service.putHiddenRead(
            userKey: userKey,
            year: year,
            month: month
        )
    }
    
    /// 리워드 아이템 오픈
    func putOpenReward(userKey: String) async throws -> [Reward] {
        try await service.putOpenReward(userKey: userKey).map { $0.toDomain() }
    }
    
    /// 월별 리워드 아이템 저장
    func putSaveReward(
        userKey: String,
        year: Int,
        month: Int,
        backgroundId: Int,
        effectId: Int,
        decorationId: Int,
        byeoltongCaseId: Int
    ) async throws {
        let bodyData = RewardSaveRequest(
            userKey: userKey,
            year: year,
            month: month,
            backgroundId: backgroundId,
            effectId: effectId,
            decorationId: decorationId,
            byeoltongCaseId: byeoltongCaseId
        )
        try await service.putSaveReward(bodyData: bodyData)
    }
}
