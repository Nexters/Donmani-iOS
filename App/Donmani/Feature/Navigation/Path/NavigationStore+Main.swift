//
//  NavigationStore+Main.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension NavigationStore {
    func mainDelegateAction(
        state: inout NavigationStore.State,
        action: MainStore.Action.Delegate
    ) -> Effect<NavigationStore.Action> {
        switch action {
        case .pushRecordListView:
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            let yearMonth = (Int(today[0])!, Int(today[1])!)
            state.recordListState = RecordListStore.State(year: yearMonth.0, month: yearMonth.1, isShowNavigationButton: true)
            GA.View(event: .recordhistory).send(parameters: [.referrer: "메인"])
            state.path.append(.recordList(state.recordListState))
            return .none
            
        case .pushRecordEntryPointView:
            let stateManager = HistoryStateManager.shared.getState()
            state.recordEntryPointState = RecordEntryPointStore.State(
                isCompleteToday: stateManager[.today, default: false],
                isCompleteYesterday: stateManager[.yesterday, default: false]
            )
            state.path.append(.recordEntryPoint(state.recordEntryPointState))
            return .none
            
        case .pushSettingView:
            state.path.append(.setting)
            return .none
            
        case .pushBottleListView(let result):
            state.bottleListState = BottleListStore.State(starCount: result)
            state.path.append(.bottleList(state.bottleListState))
            return .none
        }
    }
}
