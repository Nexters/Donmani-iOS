//
//  NavigationStore+MonthlyStarBottle.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func monthlyStarBottleDelegateAction(
        state: inout MainNavigationStore.State,
        action: MonthlyStarBottleStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pushRecordListView(let day, let records):
            return .run { send in
                await send(.push(.monthlyRecordList(day, records, false)))
            }
        }
    }
}
