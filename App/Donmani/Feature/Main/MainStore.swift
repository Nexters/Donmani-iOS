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
        
        var name: String = DataStorage.getUserName()
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        var monthlyRecords: [Record]
        var isPresentingRecordListView: Bool = false
        var isPresentingRecordEntryView: Bool = false
        var isPresentingRecordEntryButton: Bool = true
        var currentRecord: Record? = nil
        var recordEntryPointState = RecordEntryPointStore.State(isCompleteToday: true, isCompleteYesterday: true)
        
        init() {
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            self.monthlyRecords = DataStorage.getRecord(yearMonth: "\(today[0])-\(today[1])") ?? []
            let state = HistoryStateManager.shared.getState()
            self.recordEntryPointState = RecordEntryPointStore.State(
                isCompleteToday: state[.today, default: false],
                isCompleteYesterday: state[.yesterday, default: false]
            )
            self.isCompleteToday = state[.today, default: false]
            self.isCompleteYesterday = state[.yesterday, default: false]
            self.isPresentingRecordEntryButton = !(self.isCompleteToday && self.isCompleteYesterday)
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case touchStarBottle
        case touchRecordEntryButton
        case touchSettingButton
        case checkEnableRecord
        case binding(BindingAction<State>)
        case reciveRecord(RecordEntryPointStore.Action)
        
        case showReciveStar
    }
    
    // MARK: - Dependency
    
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Scope(
            state: \.recordEntryPointState,
            action: \.reciveRecord
        ) {
            RecordEntryPointStore()
        }
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchStarBottle:
                state.isPresentingRecordListView = true
                return .none
            case .touchRecordEntryButton:
                state.isPresentingRecordEntryView = true
                return .none
            case .touchSettingButton:
                return .none
            case .binding:
                return .none
            case .checkEnableRecord:
                state.isPresentingRecordEntryButton = (state.isCompleteToday || state.isCompleteYesterday)
                return .none
            case .reciveRecord(let event):
                switch event {
                case .sendToMain(let record):
                    let stateManager = HistoryStateManager.shared.getState()
                    state.recordEntryPointState = RecordEntryPointStore.State(
                        isCompleteToday: stateManager[.today, default: false],
                        isCompleteYesterday: stateManager[.yesterday, default: false]
                    )
                    state.isCompleteToday = stateManager[.today, default: false]
                    state.isCompleteYesterday = stateManager[.yesterday, default: false]
                    state.isPresentingRecordEntryButton = !(stateManager[.today, default: false] && stateManager[.yesterday, default: false])
                    DataStorage.setRecord(record)
                    state.monthlyRecords.append(record)
                    state.isPresentingRecordEntryView = false
                    state.currentRecord = record
                    return .none
                default:
                    return .none
                }
            case .showReciveStar:
                return .none
            }
        }
    }
}
