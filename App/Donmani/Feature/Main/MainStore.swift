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
        var isPresentingRecordYesterdayToopTip: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isRequestNotificationPermission: Bool = false
        var isLoading: Bool = false
        
        var yOffset: CGFloat = 0
        var shakeCount = 0
        var isNewStar = 0
        
        var opacity: CGFloat = 0.0
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
        case shakeTwice

        case delegate(Delegate)
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
            case pushBottleListView([String: SummaryMonthly])
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
                return .run { send in
                    try await Task.sleep(nanoseconds: 300_000_000)
                    await send(.checkNotificationPermission)
                }
            case .closePopover:
                state.isPresentingRecordYesterdayToopTip = false
                HistoryStateManager.shared.setLastYesterdayToopTipDay()
                return .none
            case .checkPopover:
                let historyManager = HistoryStateManager.shared
                let stateManager = historyManager.getState()
                if stateManager[.today, default: false] && !stateManager[.yesterday, default: false] {
                    if let dateString = historyManager.getLastYesterdayToopTipDay() {
                        let lastDay = Day(yyyymmdd: dateString)
                        let todayDateString = DateManager.shared.getFormattedDate(for: .today)
                        let today = Day(yyyymmdd: todayDateString)
                        state.isPresentingRecordYesterdayToopTip = today > lastDay
                    } else {
                        state.isPresentingRecordYesterdayToopTip = true
                    }
                }
                return .none
            case .showReciveStar:
                return .none
            case .checkNotificationPermission:
                if state.isRequestNotificationPermission {
                    NotificationManager().checkNotificationPermission()
                    state.isRequestNotificationPermission = false
                }
                return .none
            case .dismissNewStarBottleView:
                state.isPresentingNewStarBottle = false
                return .none
            case .dismissAlreadyWrite:
                state.isPresentingAlreadyWrite = false
                return .none
            
            case .shakeTwice:
                if state.shakeCount >= 6 {
                    state.shakeCount = 0
                    return .none
                }
                state.shakeCount += 1
                state.yOffset = state.shakeCount % 2 == 0 ? 10 : 0
                return .run { send in
                    try await Task.sleep(nanoseconds: 500_000_000)
                    await send(.shakeTwice, animation: .linear(duration: 0.5))
                }
            
                
            case .delegate:
                return .none
            }
        }
    }
}
