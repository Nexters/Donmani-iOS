//
//  MainNavigationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import UIKit
import DNetwork
import ComposableArchitecture

@Reducer
struct MainNavigationStore {
    
    @ObservableState
    struct State {
        var mainState: MainStore.State
        var path = StackState<MainNavigationStore.Path.State>()
        
        init() {
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            self.mainState = MainStore.State(today: today)
        }
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case path(StackActionOf<MainNavigationStore.Path>)
        
        case completeWriteRecordContent(RecordContent)
        case completeWriteRecord(Record)
        
        case requestAppStoreReview
        case requestNotificationPermission
        case presentCancelBottom
        
        case changeStarBottleOpacity
        
        case push(Destination)
        enum Destination {
            case setting
            
            // Record
            case record
            case recordWriting(RecordContentType, RecordContent?)
            
            // List
            case monthlyRecordList(Int, Int, Bool)
            case bottleCalendar(RecordCountSummary)
            case statistics(Int, Int)
            case monthlyStarBottle(Int, Int)
            
            // Reward
            case rewardStart(FeedbackInfo)
            case rewardReceive(Int)
            case decoration([RewardItemCategory : [Reward]])
        }
    }
    
    @Dependency(\.mainStateFactory) var stateFactory
    
    var body: some ReducerOf<Self> {
        Scope(
            state: \.mainState,
            action: \.mainAction
        ) {
            MainStore()
        }
        
        Reduce { state, action in
            switch action {
            case .mainAction(.delegate(let mainAction)):
                switch mainAction {
                case .pushSettingView:
                    return .run { send in
                        await send(.push(.setting))
                    }
                    
                case .pushRecordEntryPointView:
                    return .run { send in
                        await send(.push(.record))
                    }
                    
                case .pushRecordListView:
                    return .run { send in
                        let dateManager = DateManager.shared
                        let dayString = dateManager.getFormattedDate(for: .today)
                        let day = Day(yyyymmdd: dayString)
                        await send(.push(.monthlyRecordList(day.year, day.month, true)))
                    }
                    
                case .pushBottleCalendarView(let recordCountSummary):
                    return .run { send in
                        await send(.push(.bottleCalendar(recordCountSummary)))
                    }
                    
                case .pushRewardStartView:
                    return .run { send in
                        guard let dto = try await NetworkService.DFeedback().fetchFeedbackInfo() else {
                            return
                        }
                        let feedbackInfo = NetworkDTOMapper.mapper(dto: dto)
                        await send(.push(.rewardStart(feedbackInfo)))
                    }
                }
                
            case .path(.element(let id, let action)):
                return path(id: id, action: action, &state)

            case .push(let destination):
                return push(to: destination, &state)
                
            case .completeWriteRecordContent(let recordContent):
                UINavigationController.isBlockSwipe = true
                if let recordWritingID = state.path.ids.last {
                    state.path.pop(from: recordWritingID)
                }
                if let recordID = state.path.ids.last {
                    if case var .record(recordState) = state.path[id: recordID] {
                        recordState.updateRecordContent(content: recordContent)
                        state.path[id: recordID] = .record(recordState)
                    }
                }
                
            case .completeWriteRecord(let record):
                if HistoryStateManager.shared.getRequestAppReviewState() == nil {
                    HistoryStateManager.shared.setReadyToRequestAppReview()
                }
                UINavigationController.isBlockSwipe = false
                state.path.removeAll()
                state.mainState.appendNewRecord(record: record)
                
            case .requestAppStoreReview:
                return .run { _ in
                    await requestAppStoreReview()
                }
                
            case .requestNotificationPermission:
                return .run { send in
                    await NotificationManager().checkNotificationPermission()
                    await send(.changeStarBottleOpacity)
                }
                
            case .presentCancelBottom:
                if let lastElementID = state.path.ids.last {
                    if let pathCase = state.path[id: lastElementID] {
                        switch pathCase {
                        case .record(var childState):
                            childState.isPresentingCancel = true
                            state.path[id: lastElementID] = .record(childState)
                            
                        case .recordWriting(var childState):
                            childState.isPresentingCancel = true
                            state.path[id: lastElementID] = .recordWriting(childState)
                        default:
                            break
                        }
                    }
                }
                
            case .changeStarBottleOpacity:
                state.mainState.starBottleOpacity = 1.0
                
            default:
                break
            }
            return .none
        }
        .forEach(\.path, action: \.path)
    }
}

extension MainNavigationStore {
    @Reducer
    enum Path {
        // Record
        case record(RecordEntryPointStore)
        case recordWriting(RecordWritingStore)
        
        // List
        case monthlyRecordList(RecordListStore)
        case bottleCalendar(BottleCalendarStore)
        case statistics(StatisticsStore)
        case monthlyStarBottle(MonthlyStarBottleStore)
        
        // Reward
        case rewardStart(RewardStartStore)
        case rewardReceive(RewardReceiveStore)
        case decoration(DecorationStore)
        
        case setting(SettingStore)
    }
}
