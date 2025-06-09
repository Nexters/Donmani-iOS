//
//  StoreFactoryProtocol.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StateFactory {
    func makeMainNavigationState() -> MainNavigationStore.State
    func makeSettingState() -> SettingStore.State
    
    // Record
    func makeRecordEntryPointState(context: RecordEntryPointStore.Context) -> RecordEntryPointStore.State
    func makeRecordWritingState(context: RecordWritingStore.Context) -> RecordWritingStore.State
    
    // List
    func makeBottleCalendarState(context: RecordCountSummary) -> BottleCalendarStore.State
    func makeMonthlyRecordListState(context:  RecordListStore.Context) -> RecordListStore.State
    func makeStatisticsState(context: StatisticsStore.Context) -> StatisticsStore.State
    func makeMonthlyStarBottleState(context: MonthlyStarBottleStore.Context) -> MonthlyStarBottleStore.State
    
    // Reward
    func makeRewardStartState(context: RewardStartStore.Context) -> RewardStartStore.State
    func makeRewardReceiveState(context: RewardReceiveStore.Context) -> RewardReceiveStore.State
    func makeDecorationState(context: DecorationStore.Context) -> DecorationStore.State
}

struct MainStateFactory: StateFactory {
    func makeMainNavigationState() -> MainNavigationStore.State {
        let state = MainNavigationStore.State()
        return state
    }
    
    func makeSettingState() -> SettingStore.State {
        let state = SettingStore.State()
        return state
    }
    
    // Record
    func makeRecordEntryPointState(context: RecordEntryPointStore.Context) -> RecordEntryPointStore.State {
        let state = RecordEntryPointStore.State(context: context)
        return state
    }
    
    func makeRecordWritingState(context: RecordWritingStore.Context) -> RecordWritingStore.State {
        let state = RecordWritingStore.State(context: context)
        return state
    }
    
    // List
    func makeBottleCalendarState(context: RecordCountSummary) -> BottleCalendarStore.State {
        let state = BottleCalendarStore.State(context: context)
        return state
    }
    
    func makeMonthlyRecordListState(context: RecordListStore.Context) -> RecordListStore.State {
        let state = RecordListStore.State(context: context)
        return state
    }
    
    func makeStatisticsState(context: StatisticsStore.Context) -> StatisticsStore.State {
        let state = StatisticsStore.State(context: context)
        return state
    }
    
    func makeMonthlyStarBottleState(context: MonthlyStarBottleStore.Context) -> MonthlyStarBottleStore.State {
        let state = MonthlyStarBottleStore.State(context: context)
        return state
    }

    // Reward
    func makeRewardStartState(context: RewardStartStore.Context) -> RewardStartStore.State {
        let state = RewardStartStore.State(context: context)
        return state
    }
    
    func makeRewardReceiveState(context: RewardReceiveStore.Context) -> RewardReceiveStore.State {
        let state = RewardReceiveStore.State(context: context)
        return state
    }
    
    func makeDecorationState(context: DecorationStore.Context) -> DecorationStore.State {
        let state = DecorationStore.State(context: context)
        return state
    }
}

struct MainStateFactoryDependencyKey: DependencyKey {
    static var liveValue: StateFactory = MainStateFactory()
}

extension DependencyValues {
    var mainStateFactory: StateFactory {
        get { self[MainStateFactoryDependencyKey.self] }
        set { self[MainStateFactoryDependencyKey.self] = newValue }
    }
}
