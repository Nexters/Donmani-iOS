//
//  MainStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import UIKit
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
        var isPresentingRecordEntryButton: Bool = true
        var recordEntryPointState = RecordEntryPointStore.State(isCompleteToday: true, isCompleteYesterday: true)
        var isPresentingPopover: Bool = false
        var isLoading: Bool = false
        
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
        
        mutating func addNewRecord(_ record: Record) {
            let stateManager = HistoryStateManager.shared.getState()
            self.recordEntryPointState = RecordEntryPointStore.State(
                isCompleteToday: stateManager[.today, default: false],
                isCompleteYesterday: stateManager[.yesterday, default: false]
            )
            self.isCompleteToday = stateManager[.today, default: false]
            self.isCompleteYesterday = stateManager[.yesterday, default: false]
            self.isPresentingRecordEntryButton = !(stateManager[.today, default: false] && stateManager[.yesterday, default: false])
            DataStorage.setRecord(record)
            self.monthlyRecords.append(record)
            Task {
                let isFirstRecord = HistoryStateManager.shared.getIsFirstRecord()
                if isFirstRecord == nil {
                    let connectedScenes = await UIApplication.shared.connectedScenes
                    if let windowScene = connectedScenes.map({$0}).first as? UIWindowScene {
                        await AppStore.requestReview(in: windowScene)
                        HistoryStateManager.shared.setIsFirstRecord()
                    }
                }
            }
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case checkEnableRecord
        case fetchUserName
        case binding(BindingAction<State>)
        case closePopover
        case checkPopover
        case showReciveStar
        case checkNotificationPermission

        case delegate(Delegate)
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
        }
    }
    
    // MARK: - Dependency
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .checkEnableRecord:
                state.isPresentingRecordEntryButton = (state.isCompleteToday || state.isCompleteYesterday)
                return .none
            case .fetchUserName:
                state.name = DataStorage.getUserName()
                return .none
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
            case .checkNotificationPermission:
                NotificationManager().checkNotificationPermission()
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
