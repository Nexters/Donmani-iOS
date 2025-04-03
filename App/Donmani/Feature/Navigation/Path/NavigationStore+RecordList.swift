//
//  NavigationStore+RecordList.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension NavigationStore {
    func recordListDelegateAction(
        id: StackElementID,
        state: inout NavigationStore.State,
        action: RecordListStore.Action.Delegate
    ) -> Effect<NavigationStore.Action> {
        switch action {
        case  .pushRecordEntryPointView:
            let stateManager = HistoryStateManager.shared.getState()
            state.recordEntryPointState = RecordEntryPointStore.State(
                isCompleteToday: stateManager[.today, default: false],
                isCompleteYesterday: stateManager[.yesterday, default: false]
            )
            state.path.append(.recordEntryPoint(state.recordEntryPointState))
            return .none
            
        case  .pushBottleListView(let result):
            state.bottleListState = BottleListStore.State(starCount: result)
            state.path.append(.bottleList(state.bottleListState))
            return .none
            
        case  .pushStatisticsView(let year, let month):
            state.statisticsState = StatisticsStore.State(year: year, month: month)
            state.path.append(.statistics(state.statisticsState))
            return .none
        }
    }
}
