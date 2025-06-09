//
//  MainNavigationStore+Decoration.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func decorationDelegateAction(
        state: inout MainNavigationStore.State,
        action: DecorationStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pop(let isSaved):
            state.mainState.isSaveSuccess = isSaved
            if let settingID = state.path.ids.first {
                if case .setting(_) = state.path[id: settingID] {
                    state.path.pop(to: settingID)
                } else {
                    state.path.removeAll()
                }
            }
            return .none
        }
    }
}
