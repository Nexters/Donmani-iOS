//
//  RewardRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import DNetwork
import ComposableArchitecture

final actor RewardRepository {
    private let dataSource = RewardAPI()
    private let downloader = DownloadAPI()
    @Dependency(\.keychainDataSource) private var keychainDataSource
    @Dependency(\.rewardDataSource) private var rewardDataSource
    
    // KeychainDataSource
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    // RewardDataSource
    /// 꾸미기 정보를 저장합니다.
    func saveEquippedItems(year: Int, month: Int, items: [Reward]) async {
        await rewardDataSource.saveEquippedItems(
            year: year,
            month: month,
            items: items
        )
    }
    
    /// 꾸미기 정보를 불러옵니다.
    func loadEquippedItems(year: Int, month: Int) async -> [RewardItemCategory: Reward] {
        await rewardDataSource.loadEquippedItems(year: year, month: month)
    }
    
    /// 리워드 아이템을 저장합니다.
    func saveReward(item: Reward) async {
        await rewardDataSource.saveReward(item: item)
    }
    
    /// 리워드 아이템 리스트를 저장합니다.
    func saveRewards(items: [Reward]) async {
        await rewardDataSource.saveRewards(items: items)
    }
    
    // RewardAPI
    /// 사용자의 리워드 아이템 조회
    func getUserRewardItem() async throws -> [RewardItemCategory: [Reward]] {
        try await dataSource.getUserRewardItem(userKey: userKey).toDomain()
    }
    
    /// 열지 않은 리워드 개수 조회
    func getNotOpenRewardCount() async throws -> Int {
        try await dataSource.getNotOpenRewardCount(userKey: userKey)
    }
    
    /// 월별 착용아이템 조회
    func getMonthlyRewardItem(year: Int, month: Int) async throws -> [Reward] {
        try await dataSource.getMonthlyRewardItem(
            userKey: userKey,
            year: year,
            month: month
        ).map { $0.toDomain() }
    }
    
    /// 히든 아이템 확인 여부 업데이트
    func putHiddenRead(year: Int, month: Int) async throws {
        try await dataSource.putHiddenRead(
            userKey: userKey,
            year: year,
            month: month
        )
    }
    
    /// 리워드 아이템 오픈
    func putOpenReward() async throws -> [Reward] {
        try await dataSource.putOpenReward(userKey: userKey).map { $0.toDomain() }
    }
    
    /// 월별 리워드 아이템 저장
    func putSaveReward(
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
        try await dataSource.putSaveReward(bodyData: bodyData)
    }
    
    func downloadRewardData(from urlString: String) async throws -> Data {
        try await downloader.getResourceData(urlString: urlString)
    }
}
