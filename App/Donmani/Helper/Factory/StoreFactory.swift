//
//  StoreFactoryProtocol.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore>
    func makeBottleCalendarStore(state: BottleListStore.State) -> StoreOf<BottleListStore>
    func makeMonthlyRecordListStore(state: RecordListStore.State) -> StoreOf<RecordListStore>
    func makeStatisticsStore(state: StatisticsStore.State) -> StoreOf<StatisticsStore>
    func makeMonthlyStarBottleStore(state: MonthlyStarBottleStore.State) -> StoreOf<MonthlyStarBottleStore>
}

struct MainStoreFactory: StoreFactory {
    func makeMainNavigationStore(state: MainNavigationStore.State) -> StoreOf<MainNavigationStore> {
        let store = Store(initialState: state) { MainNavigationStore() }
        return store
    }
    
    func makeBottleCalendarStore(state: BottleListStore.State) -> StoreOf<BottleListStore> {
        let store = Store(initialState: state) { BottleListStore() }
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
