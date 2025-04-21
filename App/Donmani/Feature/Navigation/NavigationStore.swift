//
//  NavigationStore.swift
//  Donmani
//
//  Created by 문종식 on 3/19/25.
//

import SwiftUI
import ComposableArchitecture

enum RootType {
    case onboarding
    case main
}

@Reducer
struct NavigationStore {
    
    @ObservableState
    struct State {
        // 자식 View State
        var mainState: MainStore.State
//        var childMainState: MainStore.State
        var onboardingState: OnboardingStore.State
        var recordEntryPointState: RecordEntryPointStore.State
        var recordWritingState: RecordWritingStore.State
        var recordListState: RecordListStore.State
        var bottleListState: BottleListStore.State
        var monthlyStarBottleState: MonthlyStarBottleStore.State
        var statisticsState: StatisticsStore.State
        
        // Path
        var path = StackState<Path.State>()
        
        var rootType: RootType
        
        init(_ rootType: RootType) {
            self.rootType = rootType
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            self.onboardingState = OnboardingStore.State()
            self.recordEntryPointState = RecordEntryPointStore.State()
            let yearMonth = (Int(today[0])!, Int(today[1])!)
            self.recordListState = RecordListStore.State(year: yearMonth.0, month: yearMonth.1, isShowNavigationButton: true)
            self.recordWritingState = RecordWritingStore.State(type: .good)
            self.bottleListState = BottleListStore.State(recordCountSummary: RecordCountSummary(year: 2025, monthlyRecords: [:]))
            self.monthlyStarBottleState = MonthlyStarBottleStore.State(year: 0, month: 0)
            self.statisticsState = StatisticsStore.State(year: 0, month: 0)
            if rootType == .onboarding {
                self.mainState = MainStore.State()
            } else {
                self.mainState = MainStore.State(today: today)
                self.mainState.isRequestNotificationPermission = true
                self.mainState.opacity = 1.0
            }
        }
    }
    
    @Reducer
    enum Path {
        case main(MainStore)
        case recordEntryPoint(RecordEntryPointStore)
        case recordWriting(RecordWritingStore)
        case recordList(RecordListStore)
        case bottleList(BottleListStore)
        case monthlyStarBottle(MonthlyStarBottleStore)
        case statistics(StatisticsStore)
        case setting
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case onboardingAction(OnboardingStore.Action)
        case addNewRecord(Record?)
        case path(StackActionOf<Path>)
        case blockPopGesture
    }
    
    var body: some ReducerOf<Self> {
        // Main Scope
        Scope(state: \.mainState, action: \.mainAction) {
            MainStore()
        }
        
        // Onboarding Scope
        Scope(state: \.onboardingState, action: \.onboardingAction) {
            OnboardingStore()
        }
        
        Reduce { state, action in
            switch action {
                // Onboarding Action
            case .onboardingAction(.delegate(.pushMainView(let isAlreadyWrite))):
                let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                var mainState: MainStore.State = MainStore.State(today: today)
                mainState.isPresentingAlreadyWrite = isAlreadyWrite
//                mainState.isRequestNotificationPermission = true
                GA.View(event: .main).send(parameters: [.referrer: "onboarding"])
                state.path.append(.main(mainState))
                return .run { send in
                    try await Task.sleep(nanoseconds: 700_000_000)
                    await send(.addNewRecord(nil))
                    NotificationManager().checkNotificationPermission()
                }
                
            case .onboardingAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                let mainState: MainStore.State = MainStore.State(today: today)
                let screenType = state.recordEntryPointState.dayTitle
                GA.View(event: .recordmain).send(parameters: [.referrer: "onboarding", .screenType: screenType])
                state.path.append(contentsOf: [
                    .main(mainState),
                    .recordEntryPoint(state.recordEntryPointState)
                ])
                return .none
            case .onboardingAction:
                return .none
                
                // Main Action
            case .mainAction(.delegate(.pushRecordListView)):
                let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                let yearMonth = (Int(today[0])!, Int(today[1])!)
                state.recordListState = RecordListStore.State(year: yearMonth.0, month: yearMonth.1, isShowNavigationButton: true)
                GA.View(event: .recordhistory).send(parameters: [.referrer: "메인"])
                state.path.append(.recordList(state.recordListState))
                return .none
            case .mainAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                let screenType = state.recordEntryPointState.dayTitle
                GA.View(event: .recordmain).send(parameters: [.screenType: screenType])
                state.path.append(.recordEntryPoint(state.recordEntryPointState))
                return .none
            case .mainAction(.delegate(.pushSettingView)):
                state.path.append(.setting)
                return .none
            case .mainAction(.delegate(.pushBottleListView)):
                state.path.append(.bottleList(state.bottleListState))
                return .none
            case .mainAction:
                return .none
                
            case .addNewRecord(let record):
                UINavigationController.swipeNavigationPopIsEnabled = true
                if state.rootType == .onboarding {
                    if let mainViewID = state.path.ids.first {
                        if case .main(var mainState) = state.path[id: mainViewID] {
                            addNewRecord(mainState: &mainState, record: record)
                            state.path[id: mainViewID] = .main(mainState)
                        }
                    }
                } else {
                    addNewRecord(mainState: &state.mainState, record: record)
                }
                return .none
                
                // Path Action
            case .path(let element):
                return path(state: &state, pathElement: element)
                
            case .blockPopGesture:
                if let lastViewID = state.path.ids.last {
                    if case .recordEntryPoint(var recordEntryPointState) = state.path[id: lastViewID] {
                        recordEntryPointState.isPresentingCancel = true
                        state.path[id: lastViewID] = .recordEntryPoint(recordEntryPointState)
                    } else if case .recordWriting(var recordWritingState) = state.path[id: lastViewID] {
                        recordWritingState.isPresentingCancel = true
                        state.path[id: lastViewID] = .recordWriting(recordWritingState)
                    }
                }
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
