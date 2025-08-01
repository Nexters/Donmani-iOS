//
//  MainStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import UIKit
import DesignSystem
import ComposableArchitecture

@Reducer
struct MainStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var name: String = DataStorage.getUserName()
        var monthlyRecords: [Record]
        var byeoltongShapeType: DImageAsset = .rewardBottleDefaultShape
        
        var isPresentingRecordEntryButton: Bool = true
        var isPresentingRecordYesterdayToopTip: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isPresentingRewardToolTipView: Bool = false
        
        var isSaveSuccess: Bool = false
        var isPresentingSaveSuccessToastView: Bool = false
        
        var isRequestNotificationPermission: Bool = true
        var isLoading: Bool = false
        var decorationItem: [RewardItemCategory: Reward]
        var backgroundResource : DImageAsset? {
            let id = decorationItem[.background]?.id ?? 9
            switch id {
            case 9:
                return .rewardBgStarOcean
            case 10:
                return .rewardBgPurpleAurora
            case 11:
                return .rewardBgSkyPathway
            default:
                return nil
            }
        }
        var byeoltongImageType : DImageAsset {
            let id = decorationItem[.byeoltong]?.id ?? 4
            switch id {
            case 24:
                return .rewardBottleBeads
            case 25:
                return .rewardBottleFuzzy
            default:
                return .rewardBottleDefault
            }
        }
        
        var starBottleOpacity = 1.0
        var yOffset: CGFloat = 0
        var shakeCount = 0
        var isNewStar = 0
        
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
            self.decorationItem = DataStorage.getDecorationItem()
            
            if (day == 1) {
                if HistoryStateManager.shared.getIsFirstDayOfMonth() {
                    isPresentingNewStarBottle = true
                    HistoryStateManager.shared.setIsFirstDayOfMonth()
                }
            } else {
                HistoryStateManager.shared.removeIsFirstDayOfMonth()
            }
            isPresentingRewardToolTipView = HistoryStateManager.shared.getIsPresentingRewardToolTipView()
        }
        
        mutating func appendNewRecord(record: Record) {
            monthlyRecords.append(record)
            let historyStateManager = HistoryStateManager.shared
            let state = historyStateManager.getState()
            let isCompleteToday = state[.today, default: false]
            let isCompleteYesterday = state[.yesterday, default: false]
            isPresentingRecordEntryButton = !(isCompleteToday && isCompleteYesterday)
            isNewStar += 1
            let itemCount = DataStorage.getInventory().reduce(into: 0) { result, items in result += items.value.count }
            isPresentingRewardToolTipView = !(itemCount > 15)
            HistoryStateManager.shared.setIsPresentingRewardToolTipView(false)
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case fetchUserName
        case closePopover
        case checkPopover
        case dismissNewStarBottleView
        case dismissAlreadyWrite
        case shakeTwice
        case touchRewardButton
        
        case dismissSaveSuccessToast

        case delegate(Delegate)
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
            case pushBottleCalendarView(RecordCountSummary)
            case pushRewardStartView
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
                state.decorationItem = DataStorage.getDecorationItem()
                let id = state.decorationItem[.byeoltong]?.id ?? 4
                GA.View(event: .main).send()
                state.byeoltongShapeType = {
                    switch id {
                    case 24:
                        return .rewardBottleBeadsShape
                    case 25:
                        return .rewardBottleFuzzyShape
                    default:
                        return .rewardBottleDefaultShape
                    }
                }()
                if state.isSaveSuccess {
                    state.isPresentingSaveSuccessToastView = true
                    return .run { send in
                        try await Task.sleep(nanoseconds: 3_000_000_000)
                        await send(.dismissSaveSuccessToast, animation: .linear(duration: 0.5))
                    }
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
            
            case .touchRewardButton:
                GA.Click(event: .mainShopButton).send()
                if (state.isPresentingRewardToolTipView) {
                    state.isPresentingRewardToolTipView = false
                    HistoryStateManager.shared.setIsPresentingRewardToolTipView(true)
                }
                return .run { send in
                    await send(.delegate(.pushRewardStartView))
                }
                
            case .dismissSaveSuccessToast:
                state.isSaveSuccess = false
                state.isPresentingSaveSuccessToastView = false
                
            default:
                break
            }
            return .none
        }
    }
}
