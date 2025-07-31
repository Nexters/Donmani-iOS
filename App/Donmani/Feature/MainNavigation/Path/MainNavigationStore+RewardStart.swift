//
//  MainNavigationStore+RewardStart.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func rewardStartDelegateAction(
        state: inout MainNavigationStore.State,
        action: RewardStartStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case  .pushRewardReceiveView(let count):
            return .run { send in
                await send(.push(.rewardReceive(count)))
            }
        case .pushRecordEntryPointView:
            return .run { send in
                await send(.push(.record))
            }
        case .pushDecorationView(let decorationItem, let currentDecorationItem, let category):
            return .run { send in
                await send(.push(.decoration(decorationItem, currentDecorationItem, category)))
            }
        }
    }
}
