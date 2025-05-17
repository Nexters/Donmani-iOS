//
//  NavigationStore+MonthlyStarBottle.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

//extension NavigationStore {
//    func monthlyStarBottleDelegateAction(
//        id: StackElementID,
//        state: inout NavigationStore.State,
//        action: MonthlyStarBottleStore.Action.Delegate
//    ) -> Effect<NavigationStore.Action> {
//        switch action {
//        case .pushRecordListView(let year, let month):
//            let context = RecordListStore.Context(year: year, month: month, false)
//            state.recordListState = RecordListStore.State(context: context)
//            state.path.append(.recordList(state.recordListState))
//            return .none
//        }
//    }
//}
