//
//  MainStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import UIKit
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
        var isPresentingRecordEntryButton: Bool = true
        var recordEntryPointState = RecordEntryPointStore.State(isCompleteToday: true, isCompleteYesterday: true)
        var isPresentingPopover: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isLoading: Bool = false
        
        var month = 0
        var day = 0
        
        init(today: [String]) {
            self.month = Int(today[1]) ?? 1
            self.monthlyRecords = DataStorage.getRecord(yearMonth: "\(today[0])-\(today[1])") ?? []
            let state = HistoryStateManager.shared.getState()
            self.recordEntryPointState = RecordEntryPointStore.State(
                isCompleteToday: state[.today, default: false],
                isCompleteYesterday: state[.yesterday, default: false]
            )
            self.isCompleteToday = state[.today, default: false]
            self.isCompleteYesterday = state[.yesterday, default: false]
            self.isPresentingRecordEntryButton = !(self.isCompleteToday && self.isCompleteYesterday)
            
//            isNewStarBottle = true
            self.day = Int(today[2]) ?? 1
            if (day == 1) {
                if HistoryStateManager.shared.getIsFirstDayOfMonth() {
                    isPresentingNewStarBottle = true
                    HistoryStateManager.shared.setIsFirstDayOfMonth()
                }
            } else {
                HistoryStateManager.shared.removeIsFirstDayOfMonth()
            }
        }
        
        init() {
            isCompleteToday = true
            isCompleteYesterday = true
            monthlyRecords = []
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
        case dismissNewStarBottleView
        case dismissAlreadyWrite

        case delegate(Delegate)
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
            case pushBottleListView
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
            case .dismissNewStarBottleView:
                state.isPresentingNewStarBottle = false
                return .none
            case .dismissAlreadyWrite:
                state.isPresentingAlreadyWrite = false
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
