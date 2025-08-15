//
//  StoreFactoryProtocol.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StateFactory {
    func makeMainNavigationState(mainState: MainStore.State) -> MainNavigationStore.State
    func makeMainState(context: MainStore.Context) -> MainStore.State
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
    func makeMainNavigationState(mainState: MainStore.State) -> MainNavigationStore.State {
        MainNavigationStore.State(mainState: mainState)
    }
    
    func makeMainState(context: MainStore.Context) -> MainStore.State {
        MainStore.State(context: context)
    }
    
    func makeSettingState() -> SettingStore.State {
        SettingStore.State()
    }
    
    // Record
    func makeRecordEntryPointState(context: RecordEntryPointStore.Context) -> RecordEntryPointStore.State {
        RecordEntryPointStore.State(context: context)
    }
    
    func makeRecordWritingState(context: RecordWritingStore.Context) -> RecordWritingStore.State {
        RecordWritingStore.State(context: context)
    }
    
    // List
    func makeBottleCalendarState(context: RecordCountSummary) -> BottleCalendarStore.State {
        BottleCalendarStore.State(context: context)
    }
    
    func makeMonthlyRecordListState(context: RecordListStore.Context) -> RecordListStore.State {
        RecordListStore.State(context: context)
    }
    
    func makeStatisticsState(context: StatisticsStore.Context) -> StatisticsStore.State {
        StatisticsStore.State(context: context)
    }
    
    func makeMonthlyStarBottleState(context: MonthlyStarBottleStore.Context) -> MonthlyStarBottleStore.State {
        MonthlyStarBottleStore.State(context: context)
    }

    // Reward
    func makeRewardStartState(context: RewardStartStore.Context) -> RewardStartStore.State {
        RewardStartStore.State(context: context)
    }
    
    func makeRewardReceiveState(context: RewardReceiveStore.Context) -> RewardReceiveStore.State {
        RewardReceiveStore.State(context: context)
    }
    
    func makeDecorationState(context: DecorationStore.Context) -> DecorationStore.State {
        DecorationStore.State(context: context)
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
