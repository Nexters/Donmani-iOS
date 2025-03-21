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
        var onboardingState: OnboardingStore.State
        var recordEntryPointState: RecordEntryPointStore.State
        // 아직 없는 Store
        // var setting: SettingStore.State
        var recordListState: RecordListStore.State
        
        // Path
        var path = StackState<Path.State>()
        
        var rootType: RootType
        
        init(_ rootType: RootType) {
            self.rootType = rootType
            self.mainState = MainStore.State()
            self.onboardingState = OnboardingStore.State()
            self.recordEntryPointState = RecordEntryPointStore.State()
            self.recordListState = RecordListStore.State()
        }
    }
    
    @Reducer
    enum Path {
        case main(MainStore)
        case recordEntryPoint(RecordEntryPointStore)
        case recordList(RecordListStore)
        case setting
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case onboardingAction(OnboardingStore.Action)
        case path(StackActionOf<Path>)
    }
    
    //    enum NavigationAction {
    //        case onboarding(OnboardingStore.Action)
    //        case main(MainStore.Action)
    //        case recordEntryPoint(RecordEntryPointStore.Action)
    //    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.mainState, action: \.mainAction) {
            MainStore()
        }
        
        Scope(state: \.onboardingState, action: \.onboardingAction) {
            OnboardingStore()
        }
        
        Reduce { state, action in
            switch action {
            case .path(let pathAction):
                print(pathAction)
                return .none
                
                // Onboarding Action
            case .onboardingAction(.delegate(.pushMainView)):
                state.path.append(.main(state.mainState))
                return .none
            case .onboardingAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                state.path.append(contentsOf: [
                    .main(state.mainState),
                    .recordEntryPoint(state.recordEntryPointState)
                ])
                return .none
            case .onboardingAction:
                return .none
            
                // Main Action
            case .mainAction(.delegate(.pushRecordEntryPointView(let isFromMain))):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false],
                    isFromMain: isFromMain
                )
                state.path.append(contentsOf: [
                    .recordEntryPoint(state.recordEntryPointState)
                ])
                return .none
            case .mainAction(.delegate(.pushRecordListView)):
                state.path.append(contentsOf: [
                    .recordList(state.recordListState)
                ])
                return .none
            case .mainAction:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
