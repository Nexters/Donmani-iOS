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
        var name: String = DataStorage.getUserName()
        var monthlyRecords: [Record]
        var isPresentingRecordEntryButton: Bool = true
        var isPresentingRecordYesterdayToopTip: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isRequestNotificationPermission: Bool = false
        var isLoading: Bool = false
        
        var yOffset: CGFloat = 0
        var shakeCount = 0
        var isNewStar = 0
        
        var opacity: CGFloat = 1.0
        var month = 0
        var day = 0
        
        init(today: [String]) {
            self.month = Int(today[1]) ?? 1
            let monthlyRecords = DataStorage.getRecord(yearMonth: "\(today[0])-\(today[1])") ?? []
            self.monthlyRecords = monthlyRecords
            let state = HistoryStateManager.shared.getState()
            let isCompleteToday = state[.today, default: false]
            let isCompleteYesterday = state[.yesterday, default: false]
            self.isPresentingRecordEntryButton = !(isCompleteToday && isCompleteYesterday)
            
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
        
        mutating func appendNewRecord(record: Record) {
            monthlyRecords.append(record)
            let historyStateManager = HistoryStateManager.shared
            let state = historyStateManager.getState()
            let isCompleteToday = state[.today, default: false]
            let isCompleteYesterday = state[.yesterday, default: false]
            self.isPresentingRecordEntryButton = !(isCompleteToday && isCompleteYesterday)
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case fetchUserName
        case closePopover
        case checkPopover
        case checkNotificationPermission
        case dismissNewStarBottleView
        case dismissAlreadyWrite
        case shakeTwice

        case delegate(Delegate)
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
            case pushBottleCalendarView(RecordCountSummary)
        }
    }
    
    // MARK: - Dependency
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .fetchUserName:
                state.name = DataStorage.getUserName()
                return .run { send in
                    try await Task.sleep(nanoseconds: 300_000_000)
                    await send(.checkNotificationPermission)
                }
                
            case .closePopover:
                state.isPresentingRecordYesterdayToopTip = false
                HistoryStateManager.shared.setLastYesterdayToopTipDay()
                
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
                
            case .checkNotificationPermission:
                if state.isRequestNotificationPermission {
                    NotificationManager().checkNotificationPermission()
                    state.isRequestNotificationPermission = false
                }
                
            case .dismissNewStarBottleView:
                state.isPresentingNewStarBottle = false

            case .dismissAlreadyWrite:
                state.isPresentingAlreadyWrite = false
            
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
            
            default:
                break
            }
            return .none
        }
    }
}
