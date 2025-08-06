//
//  RewardDataSource.swift
//  Donmani
//
//  Created by 문종식 on 8/2/25.
//

import ComposableArchitecture

protocol RewardDataSource {
    func saveEquippedItems(year: Int, month: Int, items: [Reward]) async
    func loadEquippedItems(year: Int, month: Int) async -> [RewardItemCategory: Reward] 
    func saveReward(item: Reward) async
    func saveRewards(items: [Reward]) async
    func initRewardInventory() async
}

final actor DefaultRewardDataSource: RewardDataSource {
    // Typealias
    private typealias Year = Int
    private typealias Month = Int
    private typealias EquippedItem = [RewardItemCategory: Reward]
    private typealias MonthlyEquippedItem = [Month: EquippedItem]
    
    private var yearlyEquippedItem: [Year: MonthlyEquippedItem] = [:]
    private var userRewardInventory: [RewardItemCategory: [Reward]] = [:]
    
    func saveEquippedItems(year: Int, month: Int, items: [Reward]) {
        items.forEach { reward in
            yearlyEquippedItem
                .self[year, default: MonthlyEquippedItem()]
                .self[month, default: EquippedItem()]
                .self[reward.category] = reward
        }
    }
    
    func loadEquippedItems(year: Int, month: Int) -> [RewardItemCategory: Reward] {
        guard let monthlyEquippedItem = yearlyEquippedItem[year] else { return [:] }
        guard let equippedItems = monthlyEquippedItem[month] else { return [:] }
        return equippedItems
    }
    
    func saveReward(item: Reward) {
        userRewardInventory[item.category, default: []].append(item)
    }
    
    func saveRewards(items: [Reward]) {
        items.forEach { saveReward(item: $0) }
    }
    
    func initRewardInventory() {
        userRewardInventory = [:]
    }
}

enum RewardDataSourceDependencyKey: DependencyKey {
    static var liveValue: RewardDataSource = DefaultRewardDataSource()
}

extension DependencyValues {
    var rewardDataSource: RewardDataSource {
        get { self[RewardDataSourceDependencyKey.self] }
        set { self[RewardDataSourceDependencyKey.self] = newValue }
    }
}
