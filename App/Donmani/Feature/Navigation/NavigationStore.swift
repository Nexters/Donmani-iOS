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
        var recordWritingState: RecordWritingStore.State
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
            self.recordWritingState = RecordWritingStore.State(type: .good)
            self.recordListState = RecordListStore.State()
        }
        
        mutating func updateRecordContent(_ content: RecordContent) {
            switch content.flag {
            case .good:
                recordEntryPointState.goodRecord = content
            case .bad:
                recordEntryPointState.badRecord = content
            }
            let isSaveEnabled = !(recordEntryPointState.badRecord == nil && recordEntryPointState.goodRecord == nil)
            recordEntryPointState.isSaveEnabled = isSaveEnabled
        }
    }
    
    @Reducer
    enum Path {
        case main(MainStore)
        case recordEntryPoint(RecordEntryPointStore)
        case recordWriting(RecordWritingStore)
        case recordList(RecordListStore)
        case setting
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case onboardingAction(OnboardingStore.Action)
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
            case .onboardingAction(.delegate(.pushMainView)):
                state.path.append(.main(state.mainState))
                return .none
            case .onboardingAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                UINavigationController.swipeNavigationPopIsEnabled = false
                state.path.append(contentsOf: [
                    .main(state.mainState),
                    .recordEntryPoint(state.recordEntryPointState)
                ])
                return .none
            case .onboardingAction:
                return .none
                
                // Main Action
            case .mainAction(.delegate(.pushRecordListView)):
                state.path.append(.recordList(state.recordListState))
                return .none
            case .mainAction(.delegate(.pushRecordEntryPointView)):
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                UINavigationController.swipeNavigationPopIsEnabled = false
                state.path.append(.recordEntryPoint(state.recordEntryPointState))
                return .none
            case .mainAction(.delegate(.pushSettingView)):
                state.path.append(.setting)
                return .none
            case .mainAction:
                return .none
                
                // Path Action
            case .path(let element):
                switch element {
                case .element(id: let id, action: let action):
                    switch action {
                        // Path - Main Action
                    case .main(.delegate(.pushRecordListView)):
                        state.path.append(.recordList(state.recordListState))
                        return .none
                        
                    case .main(.delegate(.pushRecordEntryPointView)):
                        let stateManager = HistoryStateManager.shared.getState()
                        state.recordEntryPointState = RecordEntryPointStore.State(
                            isCompleteToday: stateManager[.today, default: false],
                            isCompleteYesterday: stateManager[.yesterday, default: false]
                        )
                        UINavigationController.swipeNavigationPopIsEnabled = false
                        state.path.append(.recordEntryPoint(state.recordEntryPointState))
                        return .none
                        
                    case .main(.delegate(.pushSettingView)):
                        state.path.append(.setting)
                        return .none
                        
                        // Path - Record List Action
                    case  .recordList(.delegate(.pushRecordEntryPointView)):
                        let stateManager = HistoryStateManager.shared.getState()
                        state.recordEntryPointState = RecordEntryPointStore.State(
                            isCompleteToday: stateManager[.today, default: false],
                            isCompleteYesterday: stateManager[.yesterday, default: false]
                        )
                        UINavigationController.swipeNavigationPopIsEnabled = false
                        state.path.append(.recordEntryPoint(state.recordEntryPointState))
                        return .none
                        
                        // Path - Record EntryPoint Action
                    case .recordEntryPoint(.delegate(.popToMainView)):
                        if let recordEntryPointViewID = state.path.ids.last {
                            state.path.pop(from: recordEntryPointViewID)
                        }
                        UINavigationController.swipeNavigationPopIsEnabled = true
                        return .none
                        
                    case .recordEntryPoint(.delegate(.popToMainViewWith(let record))):
                        if state.rootType == .onboarding {
                            if let mainViewID = state.path.ids.first {
                                if case .main(var mainState) = state.path[id: mainViewID] {
                                    mainState.addNewRecord(record)
                                    state.path[id: mainViewID] = .main(mainState)
                                }
                            }
                        } else {
                            state.mainState.addNewRecord(record)
                        }
                        if let recordEntryPointViewID = state.path.ids.last {
                            state.path.pop(from: recordEntryPointViewID)
                        }
                        UINavigationController.swipeNavigationPopIsEnabled = true
                        return .none
                        
                    case .recordEntryPoint(.delegate(.pushRecordWritingViewWith(let content))):
                        state.recordWritingState = RecordWritingStore.State(type: content.flag, content: content)
                        state.path.append(.recordWriting(state.recordWritingState))
                        return .none
                        
                    case .recordEntryPoint(.delegate(.pushRecordWritingView(let type))):
                        state.recordWritingState = RecordWritingStore.State(type: type)
                        state.path.append(.recordWriting(state.recordWritingState))
                        return .none
                    
                        // Path - Record Writing Action
                    case .recordWriting(.delegate(.popToRecordEntrypointView)):
                        state.path.removeLast()
                        return .none
                    
                    case .recordWriting(.delegate(.popToRecordEntrypointViewWith(let content))):
                        var recordEntrypointViewID: StackElementID?
                        for (id, element) in zip(state.path.ids, state.path) {
                            switch element {
                            case .recordEntryPoint:
                                recordEntrypointViewID = id
                            default:
                                break
                            }
                        }
                        state.updateRecordContent(content)
                        if let recordEntrypointViewID = recordEntrypointViewID {
                            state.path[id: recordEntrypointViewID] = .recordEntryPoint(state.recordEntryPointState)
                        }
                        state.path.removeLast()
                        return .none
                     
                        // Other Path Action
                    default:
                        return .none
                    }
                default:
                    return .none
                }
                
            }
        }
        .forEach(\.path, action: \.path)
    }
}
