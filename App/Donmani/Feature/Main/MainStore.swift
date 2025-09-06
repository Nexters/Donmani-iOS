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
    struct Context {
        let records: [Record]
        let hasRecord: (today: Bool, yesterday: Bool)
        let decorationItem: [RewardItemCategory: Reward]
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        var userName: String = ""
        var day: Day
        var records: [Record]
        var decorationItem: [RewardItemCategory: Reward]
 
        /// 기록 작성 가능 여부
        var canWriteRecord: Bool

        var isPresentingRecordYesterdayToolTip: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isPresentingRewardToolTipView: Bool = false
        var isSaveSuccess: Bool = false
        var isPresentingSaveSuccessToastView: Bool = false
        var isRequestNotificationPermission: Bool = true
        var isLoading: Bool = false
        var starBottleOpacity = 1.0
        var yOffset: CGFloat = 0
        var shakeCount = 0
        var isNewStar = 0
        var starBottleAction: StarBottleAction = .none
        
        init(context: MainStore.Context) {
            self.day = .today
            self.records = context.records
            self.decorationItem = context.decorationItem
            self.canWriteRecord = !(context.hasRecord.today && context.hasRecord.yesterday)
            
            if (day.day == 1) {
                // TODO: - 1일에 표시하는 Bottom Sheet
            }
            
            // TODO: - 리워드 툴팁 표시
            isPresentingRewardToolTipView = HistoryStateManager.shared.getIsPresentingRewardToolTipView()
        }
        
//        mutating func appendNewRecord(record: Record) {
//            records.append(record)
//            let historyStateManager = HistoryStateManager.shared
//            let state = historyStateManager.getState()
//            let isCompleteToday = state[.today, default: false]
//            let isCompleteYesterday = state[.yesterday, default: false]
//            canWriteRecord = !(isCompleteToday && isCompleteYesterday)
//            isNewStar += 1
//            let itemCount = DataStorage.getInventory().reduce(into: 0) { result, items in
//                result += items.value.count
//            }
//            isPresentingRewardToolTipView = !(itemCount > 15)
//            HistoryStateManager.shared.setIsPresentingRewardToolTipView(false)
//        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        
        case closePopover
        case checkPopover
        case dismissNewStarBottleView
        case dismissAlreadyWrite
        case shakeTwice
        case touchRewardButton
        
        case dismissSaveSuccessToast

        case delegate(Delegate)
        
        case update(Update)
        
        enum Update {
            case fetchUserName(String)
            case fetchDecorationItems([RewardItemCategory: Reward])
            case fetchWriteRecordButtonState(Bool)
        }
        
        enum Delegate {
            case pushSettingView
            case pushRecordEntryPointView
            case pushRecordListView
            case pushBottleCalendarView(RecordCountSummary)
            case pushRewardStartView
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.userUseCase) var userUseCase
    @Dependency(\.writeRecordUseCase) var writeRecordUseCase
    @Dependency(\.loadRewardUseCase) var loadRewardUseCase
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                GA.View(event: .main).send()
                return .run { send in
                    await send(.update(.fetchUserName(userUseCase.userName)))
                    let items = loadRewardUseCase.loadTodayDecorationItems()
                    await send(.update(.fetchDecorationItems(items)))
                    let canWriteRecord = writeRecordUseCase.canWriteRecord()
                    await send(.update(.fetchWriteRecordButtonState(canWriteRecord)))
                }
                 
            case .closePopover:
                state.isPresentingRecordYesterdayToolTip = false
                HistoryStateManager.shared.setLastYesterdayToopTipDay()
                
            case .checkPopover:
                let historyManager = HistoryStateManager.shared
                let stateManager = historyManager.getState()
                if stateManager[.today, default: false] && !stateManager[.yesterday, default: false] {
                    if let dateString = historyManager.getLastYesterdayToopTipDay() {
                        let lastDay = Day(yyyymmdd: dateString)
                        let today: Day = .today
                        state.isPresentingRecordYesterdayToolTip = today > lastDay
                    } else {
                        state.isPresentingRecordYesterdayToolTip = true
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
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 2)
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
            
                // 화면 업데이트 Action
            case .update(let update):
                switch update {
                case .fetchUserName(let userName):
                    state.userName = userName
                case .fetchDecorationItems(let item):
                    state.decorationItem = item
                case .fetchWriteRecordButtonState(let canWriteRecord):
                    state.canWriteRecord = canWriteRecord
                }
                
            default:
                break
            }
            
            return .none
        }
    }
}
