//
//  MainNavigationStore+Path.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

extension MainNavigationStore {
    func path(
        id: StackElementID,
        action: MainNavigationStore.Path.Action,
        _ state: inout MainNavigationStore.State
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .setting(.delegate(let childAction)):
            return settingDelegateAction(state: &state, action: childAction)
        
            // Record
        case .record(.delegate(let childAction)):
            return recordEntryPointDelegateAction(state: &state, action: childAction)
            
            // List
        case .monthlyRecordList(.delegate(let childAction)):
            return recordListDelegateAction(state: &state, action: childAction)
        case .bottleCalendar(.delegate(let childAction)):
            return bottleCalendarDelegateAction(state: &state, action: childAction)
        case .monthlyStarBottle(.delegate(let childAction)):
            return monthlyStarBottleDelegateAction(state: &state, action: childAction)
            
            // Reward
        case .rewardStart(.delegate(let childAction)):
            return rewardStartDelegateAction(state: &state, action: childAction)
        case .rewardReceive(.delegate(let childAction)):
            return rewardReceiveDelegateAction(state: &state, action: childAction)
        case .decoration(.delegate(let childAction)):
            return decorationDelegateAction(state: &state, action: childAction)
        default:
            return .none
        }
    }
    
    func push(
        to destination: Action.Destination,
        _ state: inout MainNavigationStore.State
    ) -> Effect<MainNavigationStore.Action> {
        switch destination {
        case .setting:
            let initialState = stateFactory.makeSettingState()
            state.path.append(.setting(initialState))
            
            // Record
        case .record:
            let isComplete = HistoryStateManager.shared.getState()
            let today = isComplete[.today, default: false]
            let yesterday = isComplete[.yesterday, default: false]
            let context = RecordEntryPointStore.Context(today: today, yesterday: yesterday)
            let initialState = stateFactory.makeRecordEntryPointState(context: context)
            state.path.append(.record(initialState))
            
        case .recordWriting(let type, let content):
            let context = RecordWritingStore.Context(type: type, content: content)
            let initialState = stateFactory.makeRecordWritingState(context: context)
            state.path.append(.recordWriting(initialState))
            
            // List
        case .monthlyRecordList(let year, let month, let isShowNavigationButton):
            let context = RecordListStore.Context(year: year, month: month, isShowNavigationButton)
            let initialState = stateFactory.makeMonthlyRecordListState(context: context)
            state.path.append(.monthlyRecordList(initialState))
            
        case .bottleCalendar(let context):
            let initialState = stateFactory.makeBottleCalendarState(context: context)
            state.path.append(.bottleCalendar(initialState))
            
        case .statistics(let year, let month):
            let context = StatisticsStore.Context(year: year, month: month)
            let initialState = stateFactory.makeStatisticsState(context: context)
            state.path.append(.statistics(initialState))
            
        case .monthlyStarBottle(let year, let month):
            let context = MonthlyStarBottleStore.Context(year: year, month: month)
            let initialState = stateFactory.makeMonthlyStarBottleState(context: context)
            state.path.append(.monthlyStarBottle(initialState))
            
            // Reward
        case .rewardStart(let feedbackInfo):
            let context = RewardStartStore.Context(
                recordCount: feedbackInfo.totalCount,
                isNotOpened: feedbackInfo.isNotOpened,
                isFirstOpened: feedbackInfo.isFirstOpened
            )
            let initialState = stateFactory.makeRewardStartState(context: context)
            state.path.append(.rewardStart(initialState))
            
        case .rewardReceive(let count):
//            let previewData = Reward.previewAllData
            let context = RewardReceiveStore.Context(rewardCount: count)
            let initialState = stateFactory.makeRewardReceiveState(context: context)
            state.path.append(.rewardReceive(initialState))
            
        case .decoration(let decorationItem):
            let context = DecorationStore.Context(decorationItem: decorationItem)
            let initialState = stateFactory.makeDecorationState(context: context)
            state.path.append(.decoration(initialState))
        }
        
        return .none
    }
}
