//
//  NavigationStore+RecordList.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func recordListDelegateAction(
        state: inout MainNavigationStore.State,
        action: RecordListStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
//        case  .pushRecordEntryPointView:
//            let stateManager = HistoryStateManager.shared.getState()
//            state.recordEntryPointState = RecordEntryPointStore.State(
//                isCompleteToday: stateManager[.today, default: false],
//                isCompleteYesterday: stateManager[.yesterday, default: false]
//            )
//            state.path.append(.recordEntryPoint(state.recordEntryPointState))
//            return .none

        
        case .pushBottleCalendarView(let result):
            return .run { send in
                await send(.push(.bottleCalendar(result)))
            }
        case  .pushStatisticsView(let year, let month):
            return .run { send in
                await send(.push(.statistics(year, month)))
            }
        default: break
        }
        return .none
    }
}
