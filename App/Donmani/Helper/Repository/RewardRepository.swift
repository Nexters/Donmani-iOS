//
//  RewardRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/31/25.
//

import DNetwork
import ComposableArchitecture

protocol RewardRepository {
    func saveEquippedItems(year: Int, month: Int, items: [Reward])
    func loadEquippedItems(year: Int, month: Int) -> [RewardItemCategory: Reward]
    func saveReward(item: Reward)
    func saveRewards(items: [RewardItemCategory: [Reward]])
    func saveRewards(items: [Reward])
    func getUserRewardItem() async throws -> [RewardItemCategory: [Reward]]
    func getNotOpenRewardCount() async throws -> Int
    func getMonthlyRewardItem(year: Int, month: Int) async throws -> [Reward]
    func putHiddenRead(year: Int, month: Int) async throws
    func putOpenReward() async throws -> [Reward]
    func putSaveReward(year: Int, month: Int, backgroundId: Int, effectId: Int, decorationId: Int, byeoltongCaseId: Int) async throws
}

struct DefaultRewardRepository: RewardRepository {
    private let dataSource = RewardAPI()
    private var keychainDataSource: KeychainDataSource
    private var rewardDataSource: RewardDataSource
    
    init(
        keychainDataSource: KeychainDataSource,
        rewardDataSource: RewardDataSource
    ) {
        self.keychainDataSource = keychainDataSource
        self.rewardDataSource = rewardDataSource
    }
    
    // KeychainDataSource
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    // RewardDataSource
    /// 꾸미기 정보를 저장합니다.
    func saveEquippedItems(year: Int, month: Int, items: [Reward]) {
        rewardDataSource.saveEquippedItems(
            year: year,
            month: month,
            items: items
        )
    }
    
    /// 꾸미기 정보를 불러옵니다.
    func loadEquippedItems(year: Int, month: Int) -> [RewardItemCategory: Reward] {
        rewardDataSource.loadEquippedItems(year: year, month: month)
    }
    
    /// 리워드 아이템을 저장합니다.
    func saveReward(item: Reward) {
        rewardDataSource.saveReward(item: item)
    }
    
    /// 리워드 아이템 리스트를 저장합니다.([RewardItemCategory: [Reward]])
    func saveRewards(items: [RewardItemCategory: [Reward]]) {
        items.forEach { item in rewardDataSource.saveRewards(items: item.value) }
    }
    
    /// 리워드 아이템 리스트를 저장합니다.([Reward])
    func saveRewards(items: [Reward]) {
        rewardDataSource.saveRewards(items: items)
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
}

extension DependencyValues {
    private enum RewardRepositoryKey: DependencyKey {
        static let liveValue: RewardRepository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            @Dependency(\.rewardDataSource) var rewardDataSource
            return DefaultRewardRepository(
                keychainDataSource: keychainDataSource,
                rewardDataSource: rewardDataSource
            )
        }()
    }
    
    var rewardRepository: RewardRepository {
        get { self[RewardRepositoryKey.self] }
        set { self[RewardRepositoryKey.self] = newValue }
    }
}
