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
                let hasTodayRecord = recordRepository.load(date: .today).isSome
                let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                await send(.push(.record(hasTodayRecord, hasYesterdayRecord)))
            }
        case .pushDecorationView(let records, let decorationItem, let currentDecorationItem, let category):
            return .run { send in
                let decorationData = convertDecorationData(rewards: currentDecorationItem)
                await send(.push(.decoration(records, decorationItem, currentDecorationItem, category, decorationData)))
            }
        }
    }
}
