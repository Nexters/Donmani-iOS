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
        
        init(mainState: MainStore.State) {
            self.mainState = mainState
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
            case setting(String)
            
            // Record
            case record
            case recordWriting(RecordContentType, RecordContent?)
            
            // List
            case monthlyRecordList(Day, [Record], Bool)
            case bottleCalendar(RecordCountSummary)
            case statistics(Day, [Record])
            case monthlyStarBottle(Day, [Record], [Reward])
            
            // Reward
            case rewardStart(FeedbackInfo)
            case rewardReceive(Int)
            case decoration([RewardItemCategory : [Reward]], [Reward], RewardItemCategory)
        }
    }
    
    @Dependency(\.mainStateFactory) var stateFactory
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.feedbackRepository) var feedbackRepository
    
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
                        let userName = userRepository.getUserName()
                        await send(.push(.setting(userName)))
                    }
                    
                case .pushRecordEntryPointView:
                    return .run { send in
                        await send(.push(.record))
                    }
                    
                case .pushRecordListView:
                    return .run { send in
                        let today: Day = .today
                        let monthlyRecordState = try await recordRepository.getMonthlyRecordList(
                            year: today.year,
                            month: today.month
                        )
                        let records = monthlyRecordState.records ?? []
                        await send(.push(.monthlyRecordList(.today, records, true)))
                    }
                    
                case .pushBottleCalendarView(let recordCountSummary):
                    return .run { send in
                        await send(.push(.bottleCalendar(recordCountSummary)))
                    }
                    
                case .pushRewardStartView:
                    return .run { send in
                        let feedbackInfo = try await feedbackRepository.getFeedbackState()
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
