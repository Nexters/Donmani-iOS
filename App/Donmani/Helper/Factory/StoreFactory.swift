//
//  StoreFactoryProtocol.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore>
    func makeRecordNavigationStore(state: RecordNavigationStore.State) -> StoreOf<RecordNavigationStore>
    
    func makeBottleCalendarStore(state: BottleCalendarStore.State) -> StoreOf<BottleCalendarStore>
    func makeMonthlyRecordListStore(state: RecordListStore.State) -> StoreOf<RecordListStore>
    func makeStatisticsStore(state: StatisticsStore.State) -> StoreOf<StatisticsStore>
    func makeMonthlyStarBottleStore(state: MonthlyStarBottleStore.State) -> StoreOf<MonthlyStarBottleStore>
    func makeRecordEntryPointStore(state: RecordEntryPointStore.State) -> StoreOf<RecordEntryPointStore>
    func makeRecordWritingStore(state: RecordWritingStore.State) -> StoreOf<RecordWritingStore>
}

struct MainStoreFactory: StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore> {
        let store = Store(initialState: state) { MainNavigationStore() }
        return store
    }
    
    func makeRecordNavigationStore(state: RecordNavigationStore.State) -> StoreOf<RecordNavigationStore> {
        let store = Store(initialState: state) { RecordNavigationStore() }
        return store
    }
    
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
    
    func makeRecordEntryPointStore(state: RecordEntryPointStore.State) -> StoreOf<RecordEntryPointStore> {
        let store = Store(initialState: state) { RecordEntryPointStore() }
        return store
    }
    
    func makeRecordWritingStore(state: RecordWritingStore.State) -> StoreOf<RecordWritingStore> {
        let store = Store(initialState: state) { RecordWritingStore() }
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
