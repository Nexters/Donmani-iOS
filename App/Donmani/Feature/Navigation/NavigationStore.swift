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
            if rootType == .onboarding {
                self.mainState = MainStore.State()
            } else {
                self.mainState = MainStore.State(today: today)
            }
            self.onboardingState = OnboardingStore.State()
            self.recordEntryPointState = RecordEntryPointStore.State()
            let yearMonth = (Int(today[0])!, Int(today[1])!)
            self.recordListState = RecordListStore.State(year: yearMonth.0, month: yearMonth.1, isShowNavigationButton: true)
            self.bottleListState = BottleListStore.State(starCount: [:])
            self.monthlyStarBottleState = MonthlyStarBottleStore.State(year: 0, month: 0)
            self.statisticsState = StatisticsStore.State(year: 0, month: 0)
        }
    }
    
    @Reducer
    enum Path {
        case main(MainStore)
        case recordEntryPoint(RecordEntryPointStore)
        case recordList(RecordListStore)
        case bottleList(BottleListStore)
        case monthlyStarBottle(MonthlyStarBottleStore)
        case statistics(StatisticsStore)
        case setting
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case onboardingAction(OnboardingStore.Action)
        case addNewRecord(Record)
        case path(StackActionOf<Path>)
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
                state.path.append(.main(mainState))
                return .none
                
            case .onboardingAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                let mainState: MainStore.State = MainStore.State(today: today)
                state.path.append(contentsOf: [
                    .main(mainState),
                    .recordEntryPoint(state.recordEntryPointState)
                ])
                return .none
            case .onboardingAction:
                return .none
                
                // Main Action
            case .mainAction(.delegate(.pushRecordListView)):
                UINavigationController.swipeNavigationPopIsEnabled = true
                state.path.append(.recordList(state.recordListState))
                return .none
            case .mainAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                state.path.append(.recordEntryPoint(state.recordEntryPointState))
                return .none
            case .mainAction(.delegate(.pushSettingView)):
                UINavigationController.swipeNavigationPopIsEnabled = true
                state.path.append(.setting)
                return .none
            case .mainAction(.delegate(.pushBottleListView)):
                state.path.append(.bottleList(state.bottleListState))
                return .none
            case .mainAction:
                return .none
                
            case .addNewRecord(let record):
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
            }
        }
        .forEach(\.path, action: \.path)
    }
}
