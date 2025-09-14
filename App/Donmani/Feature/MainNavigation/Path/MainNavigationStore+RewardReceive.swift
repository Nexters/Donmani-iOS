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
        case .pushDecorationView(let records, let decorationItem, let currentDecorationItem, let category):
            return .run { send in
                let decorationData = convertDecorationData(rewards: currentDecorationItem)
                await send(.push(.decoration(records, decorationItem, currentDecorationItem, category, decorationData)))
            }
            
        case .popToRoot:
            state.path.removeAll()
            return .none
        }
    }
}
