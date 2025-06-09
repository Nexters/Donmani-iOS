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
        let store = Store(initialState: state) { MainNavigationStore() }
        return store
    }
    
    func makeSettingStore(state: SettingStore.State) -> StoreOf<SettingStore> {
        let store = Store(initialState: state) { SettingStore() }
        return store
    }
    
    // Record
    func makeRecordEntryPointStore(state: RecordEntryPointStore.State) -> StoreOf<RecordEntryPointStore> {
        let store = Store(initialState: state) { RecordEntryPointStore() }
        return store
    }
    
    func makeRecordWritingStore(state: RecordWritingStore.State) -> StoreOf<RecordWritingStore> {
        let store = Store(initialState: state) { RecordWritingStore() }
        return store
    }
    
    // List
    func makeBottleCalendarStore(state: BottleCalendarStore.State) -> StoreOf<BottleCalendarStore> {
        let store = Store(initialState: state) { BottleCalendarStore() }
        return store
    }
    
    func makeMonthlyRecordListStore(state: RecordListStore.State) -> StoreOf<RecordListStore> {
        let store = Store(initialState: state) { RecordListStore() }
        return store
    }
    
    func makeStatisticsStore(state: StatisticsStore.State) -> StoreOf<StatisticsStore> {
        let store = Store(initialState: state) { StatisticsStore() }
        return store
    }
    
    func makeMonthlyStarBottleStore(state: MonthlyStarBottleStore.State) -> StoreOf<MonthlyStarBottleStore> {
        let store = Store(initialState: state) { MonthlyStarBottleStore() }
        return store
    }
    
    // Reward
    func makeRewardStartStore(state: RewardStartStore.State) -> StoreOf<RewardStartStore> {
        let store = Store(initialState: state) { RewardStartStore() }
        return store
    }
    
    func makeRewardReceiveStore(state: RewardReceiveStore.State) -> StoreOf<RewardReceiveStore> {
        let store = Store(initialState: state) { RewardReceiveStore() }
        return store
    }
    
    func makeDecorationStore(state: DecorationStore.State) -> StoreOf<DecorationStore> {
        let store = Store(initialState: state) { DecorationStore() }
        return store
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
