//
//  NavigationStore+MonthlyStarBottle.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension NavigationStore {
    func monthlyStarBottleDelegateAction(
        id: StackElementID,
        state: inout NavigationStore.State,
        action: MonthlyStarBottleStore.Action.Delegate
    ) -> Effect<NavigationStore.Action> {
        switch action {
        case .popToPreviousView:
            state.path.pop(from: id)
            return .none
            
        case .pushRecordListView(let year, let month):
            state.recordListState = RecordListStore.State(year: year, month: month, isShowNavigationButton: false)
            state.path.append(.recordList(state.recordListState))
            return .none
        }
    }
}
