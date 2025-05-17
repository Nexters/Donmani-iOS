//
//  StoreFactoryProtocol.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

protocol StateFactory {
    func makeMainNavigationState() -> MainNavigationStore.State
    func makeRecordNavigationState(context: RecordEntryPointStore.Context) -> RecordNavigationStore.State
    
    func makeBottleCalendarState(context: RecordCountSummary) -> BottleCalendarStore.State
    func makeMonthlyRecordListState(context:  RecordListStore.Context) -> RecordListStore.State
    func makeStatisticsState(context: StatisticsStore.Context) -> StatisticsStore.State
    func makeMonthlyStarBottleState(context: MonthlyStarBottleStore.Context) -> MonthlyStarBottleStore.State
    func makeRecordEntryPointState(context: RecordEntryPointStore.Context) -> RecordEntryPointStore.State
    func makeRecordWritingState(context: RecordWritingStore.Context) -> RecordWritingStore.State
}

struct MainStateFactory: StateFactory {
    func makeMainNavigationState() -> MainNavigationStore.State {
        let state = MainNavigationStore.State()
        return state
    }
    
    func makeRecordNavigationState(context: RecordEntryPointStore.Context) -> RecordNavigationStore.State {
        let recordState = makeRecordEntryPointState(context: context)
        let state = RecordNavigationStore.State(recordState: recordState)
        return state
    }
    
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
    
    func makeRecordEntryPointState(context: RecordEntryPointStore.Context) -> RecordEntryPointStore.State {
        let state = RecordEntryPointStore.State(context: context)
        return state
    }
    
    func makeRecordWritingState(context: RecordWritingStore.Context) -> RecordWritingStore.State {
        let state = RecordWritingStore.State(context: context)
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
