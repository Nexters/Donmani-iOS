//
//  MainNavigationStore+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

extension MainNavigationStore {
    func path(
        element: StackActionOf<MainNavigationStore.Path>,
        _ state: inout MainNavigationStore.State
    ) -> Effect<MainNavigationStore.Action> {
        switch element {
        case .element(id: _, action: let action):
            switch action {
            case .monthlyRecordList(.delegate(let childAction)):
                return recordListDelegateAction(state: &state, action: childAction)
            case .bottleCalendar(.delegate(let childAction)):
                return bottleCalendarDelegateAction(state: &state, action: childAction)
            case .monthlyStarBottle(.delegate(let childAction)):
                return monthlyStarBottleDelegateAction(state: &state, action: childAction)
            default:
                break
            }
        default:
            break
        }
        return .none
    }
    
    func push(
        to destination: Action.Destination,
        _ state: inout MainNavigationStore.State
    ) -> Effect<MainNavigationStore.Action> {
        switch destination {
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
        }
        
        return .none
    }
    
    func runMainAction(
        _ action: MainStore.Action.Delegate,
        _ state: inout MainNavigationStore.State
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pushSettingView:
            state.path.append(.setting)
        case .pushRecordEntryPointView:
            break
        case .pushRecordListView:
            return .run { send in
                let dateManager = DateManager.shared
                let dayString = dateManager.getFormattedDate(for: .today)
                let day = Day(yyyymmdd: dayString)
                await send(.push(.monthlyRecordList(day.year, day.month, true)))
            }
        case .pushBottleListView(let recordCountSummary):
            return .run { send in
                await send(.push(.bottleCalendar(recordCountSummary)))
            }
        }
        return .none
    }
}
