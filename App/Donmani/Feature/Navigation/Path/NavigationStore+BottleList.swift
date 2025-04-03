//
//  NavigationStore+BottleList.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension NavigationStore {
    func bottleListDelegateAction(
        id: StackElementID,
        state: inout NavigationStore.State,
        action: BottleListStore.Action.Delegate
    ) -> Effect<NavigationStore.Action> {
        switch action {
        case .popToPreviousView:
            state.path.pop(to: id)
            return .none
            
        case .pushMonthlyBottleView(let year, let month):
            UINavigationController.swipeNavigationPopIsEnabled = true
            state.monthlyStarBottleState = MonthlyStarBottleStore.State(year: year, month: month)
            state.path.append(.monthlyStarBottle(state.monthlyStarBottleState))
            return .none
        }
    }
}
