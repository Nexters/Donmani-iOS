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
        case  .pushRecordEntryPointView:
            return .run { send in
                let hasTodayRecord = recordRepository.load(date: .today).isSome
                let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                await send(.push(.record(hasTodayRecord, hasYesterdayRecord)))
            }
        
        case .pushBottleCalendarView(let result):
            return .run { send in
                await send(.push(.bottleCalendar(result)))
            }
        case  .pushStatisticsView(let day, let records):
            return .run { send in
                await send(.push(.statistics(day, records)))
            }
        }
    }
}
