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
//        let decorationItem: [RewardItemCategory: Reward]
        let isPresentingNewStarBottle: Bool
        let decorationData: DecorationData
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        var userName: String = ""
        var day: Day
        var records: [Record]
//        var decorationItem: [RewardItemCategory: Reward]
        var decorationData: DecorationData
 
        /// 기록 작성 가능 여부
        var canWriteRecord: Bool

        var isPresentingRecordYesterdayToolTip: Bool = false
        var isPresentingAlreadyWrite: Bool = false
        var isPresentingNewStarBottle: Bool = false
        var isPresentingRewardToolTipView: Bool
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
//            self.decorationItem = context.decorationItem
            self.decorationData = context.decorationData
            self.canWriteRecord = !(context.hasRecord.today && context.hasRecord.yesterday)
            self.isPresentingNewStarBottle = context.isPresentingNewStarBottle
            
            // TODO: - 리워드 툴팁 표시
            isPresentingRewardToolTipView = HistoryStateManager.shared.getIsPresentingRewardToolTipView()
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case fetchRewardItem(DecorationData)
        
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
            case changeBackgroundItem(Data)
            case changeEffectItem(Data)
            case changeDecorationItem(Int, String)
            case changeBottleShapeItem(Int, BottleShape)
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
    @Dependency(\.fileRepository) var fileRepository
    @Dependency(\.rewardRepository) var rewardRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                GA.View(event: .main).send()
//                let items = loadRewardUseCase.loadTodayDecorationItems()
//                state.decorationItem = items
                state.userName = userUseCase.userName
                state.canWriteRecord = writeRecordUseCase.canWriteRecord()
//                return .run { send in
//                    let day: Day = .today
//                    let items = rewardRepository.loadEquippedItems(year: day.year, month: day.month)

//                }
                return .run { send in
                    let day: Day = .today
                    let items = rewardRepository.loadEquippedItems(year: day.year, month: day.month)
                    let backgroundRewardData: Data? = items[.background].map { try? fileRepository.loadRewardData(from: $0, resourceType: .image) }
                    let effectRewardData: Data? = items[.effect].map { try? fileRepository.loadRewardData(from: $0, resourceType: .json) }
                    let decorationRewardName: String? = items[.decoration].map { RewardResourceMapper(id: $0.id, category: .decoration).resource() }
                    let decorationRewardId: Int? = items[.decoration]?.id
                    let bottleRewardId: Int? = items[.bottle].map { $0.id }
                    let bottleShape: BottleShape = bottleRewardId.map { BottleShape(id: $0) } ?? .default
                    let decorationData = DecorationData(
                        backgroundRewardData: backgroundRewardData,
                        effectRewardData: effectRewardData,
                        decorationRewardName: decorationRewardName,
                        decorationRewardId: decorationRewardId,
                        bottleRewardId: bottleRewardId,
                        bottleShape: bottleShape
                    )
                    await send(.fetchRewardItem(decorationData))
                    
                    for (category, item) in items {
                        switch category {
                        case .background:
                            let data = try fileRepository.loadRewardData(from: item, resourceType: .image)
                            await send(.update(.changeBackgroundItem(data)))
                        case .effect:
                            let data = try fileRepository.loadRewardData(from: item, resourceType: .json)
                            await send(.update(.changeEffectItem(data)))
                        case .decoration:
                            let name = RewardResourceMapper(
                                id: item.id,
                                category: .decoration
                            ).resource()
                            await send(.update(.changeDecorationItem(item.id, name)))
                        case .bottle:
                            await send(.update(.changeBottleShapeItem(item.id, BottleShape(id: item.id))))
                        case .sound:
                            break
                        }
                    }
                }
//                    let canWriteRecord =
//                    await send(.update(.fetchWriteRecordButtonState(canWriteRecord)))
//                }
                
            case .fetchRewardItem(let decorationData):
                state.decorationData = decorationData
                
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
                case .changeBackgroundItem(let data):
                    state.starBottleAction = .changeBackgroundItem(data)
                case .changeEffectItem(let data):
                    state.starBottleAction = .changeEffectItem(data)
                case .changeDecorationItem(let id, let name):
                    state.starBottleAction = .changeDecorationItem(id, name)
                case .changeBottleShapeItem(let id, let bottleShape):
                    state.starBottleAction = .changeBottleItem(id, bottleShape)
                }
                
            default:
                break
            }
            
            return .none
        }
    }
}
