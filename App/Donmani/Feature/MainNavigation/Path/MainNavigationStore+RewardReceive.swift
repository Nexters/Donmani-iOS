//
//  MainNavigationStore+RewardReceive.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func rewardReceiveDelegateAction(
        state: inout MainNavigationStore.State,
        action: RewardReceiveStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case  .pushDecorationView:
            return .run { send in
                await send(.push(.decoration))
            }
        }
    }
}
