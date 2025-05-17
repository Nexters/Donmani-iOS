//
//  NavigationStore+BottleList.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func bottleCalendarDelegateAction(
        state: inout MainNavigationStore.State,
        action: BottleCalendarStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pushMonthlyBottleView(let year, let month):
            return .run { send in
                await send(.push(.monthlyStarBottle(year, month)))
            }
        }
    }
}
