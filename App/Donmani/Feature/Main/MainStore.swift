//
//  MainStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import ComposableArchitecture

@Reducer
struct MainStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        enum DayType {
            case today
            case yesterday
        }
        
        var name: String = "행복한 코알라"
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        var monthlyRecords: [RecordContent] = []
        var isPresentingRecordEntryView: Bool = false
        var recordEntryPointState = RecordEntryPointStore.State(isCompleteToday: true, isCompleteYesterday: true)
        
        init() {
            let state = HistoryStateManager.shared.getState()
            self.recordEntryPointState = RecordEntryPointStore.State(
                isCompleteToday: state[.today, default: false],
                isCompleteYesterday: state[.yesterday, default: false]
            )
            self.isCompleteToday = state[.today, default: false]
            self.isCompleteYesterday = state[.yesterday, default: false]
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case touchStarBottle
        case touchRecordEntryButton
        case binding(BindingAction<State>)
    }
    
    // MARK: - Dependency
    @Dependency(\.recordDAO) var recordDAO
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchStarBottle:
                return .none
            case .touchRecordEntryButton:
                state.isPresentingRecordEntryView = true
                return .none
            case .binding:
                return .none
            }
        }
    }
    
}
