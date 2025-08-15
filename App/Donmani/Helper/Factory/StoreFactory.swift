//
//  StoreFactoryProtocol.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore>
    func makeSettingStore(state: SettingStore.State) -> StoreOf<SettingStore>
    
    // Record
    func makeRecordEntryPointStore(state: RecordEntryPointStore.State) -> StoreOf<RecordEntryPointStore>
    func makeRecordWritingStore(state: RecordWritingStore.State) -> StoreOf<RecordWritingStore>
    
    // List
    func makeBottleCalendarStore(state: BottleCalendarStore.State) -> StoreOf<BottleCalendarStore>
    func makeMonthlyRecordListStore(state: RecordListStore.State) -> StoreOf<RecordListStore>
    func makeStatisticsStore(state: StatisticsStore.State) -> StoreOf<StatisticsStore>
    func makeMonthlyStarBottleStore(state: MonthlyStarBottleStore.State) -> StoreOf<MonthlyStarBottleStore>
    
    // Reward
    func makeRewardStartStore(state: RewardStartStore.State) -> StoreOf<RewardStartStore>
    func makeRewardReceiveStore(state: RewardReceiveStore.State) -> StoreOf<RewardReceiveStore>
    func makeDecorationStore(state: DecorationStore.State) -> StoreOf<DecorationStore>
}

struct MainStoreFactory: StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore> {
        Store(initialState: state) { MainNavigationStore() }
    }
    
    func makeSettingStore(state: SettingStore.State) -> StoreOf<SettingStore> {
        Store(initialState: state) { SettingStore() }
    }
    
    // Record
    func makeRecordEntryPointStore(state: RecordEntryPointStore.State) -> StoreOf<RecordEntryPointStore> {
        Store(initialState: state) { RecordEntryPointStore() }
    }
    
    func makeRecordWritingStore(state: RecordWritingStore.State) -> StoreOf<RecordWritingStore> {
        Store(initialState: state) { RecordWritingStore() }
    }
    
    // List
    func makeBottleCalendarStore(state: BottleCalendarStore.State) -> StoreOf<BottleCalendarStore> {
        Store(initialState: state) { BottleCalendarStore() }
    }
    
    func makeMonthlyRecordListStore(state: RecordListStore.State) -> StoreOf<RecordListStore> {
        Store(initialState: state) { RecordListStore() }
    }
    
    func makeStatisticsStore(state: StatisticsStore.State) -> StoreOf<StatisticsStore> {
        Store(initialState: state) { StatisticsStore() }
    }
    
    func makeMonthlyStarBottleStore(state: MonthlyStarBottleStore.State) -> StoreOf<MonthlyStarBottleStore> {
        Store(initialState: state) { MonthlyStarBottleStore() }
    }
    
    // Reward
    func makeRewardStartStore(state: RewardStartStore.State) -> StoreOf<RewardStartStore> {
        Store(initialState: state) { RewardStartStore() }
    }
    
    func makeRewardReceiveStore(state: RewardReceiveStore.State) -> StoreOf<RewardReceiveStore> {
        Store(initialState: state) { RewardReceiveStore() }
    }
    
    func makeDecorationStore(state: DecorationStore.State) -> StoreOf<DecorationStore> {
        Store(initialState: state) { DecorationStore() }
    }
}

struct MainStoreFactoryDependencyKey: DependencyKey {
    static var liveValue: StoreFactory = MainStoreFactory()
}

extension DependencyValues {
    var mainStoreFactory: StoreFactory {
        get { self[MainStoreFactoryDependencyKey.self] }
        set { self[MainStoreFactoryDependencyKey.self] = newValue }
    }
}
