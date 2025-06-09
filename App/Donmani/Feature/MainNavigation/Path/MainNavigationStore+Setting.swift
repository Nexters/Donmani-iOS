//
//  MainNavigationStore+Setting.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func settingDelegateAction(
        state: inout MainNavigationStore.State,
        action: SettingStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pushDecoration(let decorationItem, let currentDecorationItem):
            return .run { send in
                await send(.push(.decoration(decorationItem, currentDecorationItem, .background)))
            }
        }
    }
}
