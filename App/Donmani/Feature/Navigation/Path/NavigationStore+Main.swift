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
            UINavigationController.swipeNavigationPopIsEnabled = true
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
            UINavigationController.swipeNavigationPopIsEnabled = true
            state.path.append(.setting)
            return .none
            
        case .pushBottleListView(let result):
            UINavigationController.swipeNavigationPopIsEnabled = true
            state.bottleListState = BottleListStore.State(starCount: result)
            state.path.append(.bottleList(state.bottleListState))
            return .none
        }
    }
}
