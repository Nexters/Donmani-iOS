//
//  MainStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import ComposableArchitecture
import StoreKit

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
//        var currentRecord: Record? = nil
        var recordEntryPointState = RecordEntryPointStore.State(isCompleteToday: true, isCompleteYesterday: true)
        var isPresentingUpdateApp: Bool
        var isPresentingPopover: Bool = false
        var isLoading: Bool = false
        
        init(isLatestVersion: Bool) {
            self.isPresentingUpdateApp = !isLatestVersion
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
        case presentRecordListView
        case touchRecordEntryButton
        case touchSettingButton
        case checkEnableRecord
        case fetchUserName
        case binding(BindingAction<State>)
        case reciveRecord(RecordEntryPointStore.Action)
        case closePopover
        case checkPopover
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
                state.isLoading = true
                return .run { send in
                    await send(.presentRecordListView)
                }
            case .presentRecordListView:
                state.isLoading = false
                state.isPresentingRecordListView = true
                return .none
            case .touchRecordEntryButton:
                let stateManager = HistoryStateManager.shared.getState()
                state.recordEntryPointState = RecordEntryPointStore.State(
                    isCompleteToday: stateManager[.today, default: false],
                    isCompleteYesterday: stateManager[.yesterday, default: false]
                )
                state.isPresentingRecordEntryView = true
                return .none
            case .touchSettingButton:
                return .none
            case .binding:
                return .none
            case .checkEnableRecord:
                state.isPresentingRecordEntryButton = (state.isCompleteToday || state.isCompleteYesterday)
                return .none
            case .fetchUserName:
                state.name = DataStorage.getUserName()
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
//                    state.currentRecord = record
                    return .run { _ in
                        let isFirstRecord = HistoryStateManager.shared.getIsFirstRecord()
                        if isFirstRecord == nil {
                            let connectedScenes = await UIApplication.shared.connectedScenes
                            if let windowScene = connectedScenes.map({$0}).first as? UIWindowScene {
                                await AppStore.requestReview(in: windowScene)
                                HistoryStateManager.shared.setIsFirstRecord()
                            }
                        }
                    }
                default:
                    return .none
                }
            case .closePopover:
                state.isPresentingPopover = false
                return .none
            case .checkPopover:
                let stateManager = HistoryStateManager.shared.getState()
                if stateManager[.today, default: false] && !stateManager[.yesterday, default: false] {
                    state.isPresentingPopover = true
                }
                return .none
            case .showReciveStar:
                return .none
            }
        }
    }
}
