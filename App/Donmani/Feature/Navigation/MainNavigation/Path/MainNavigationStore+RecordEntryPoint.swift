//
//  NavigationStore+RecordEntryPoint.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func recordEntryPointDelegateAction(
        state: inout MainNavigationStore.State,
        action: RecordEntryPointStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pushRecordWritingViewWith(let content):
            return .run { send in
                await send(.push(.recordWriting(content.flag, content)))
            }
        case .pushRecordWritingView(let type):
            return .run { send in
                await send(.push(.recordWriting(type, nil)))
            }
//        case .popToMainView(let record):
//            if state.rootType == .onboarding {
//                if let mainViewID = state.path.ids.first {
//                    if case .main(var mainState) = state.path[id: mainViewID] {
//                        mainState.isRequestNotificationPermission = true
//                        state.path[id: mainViewID] = .main(mainState)
//                        state.path.pop(to: mainViewID)
//                    }
//                }
//            } else {
//                state.path.removeAll()
//                state.mainState.isRequestNotificationPermission = true
//            }
//            NotificationManager().checkNotificationPermission()
//            return .run { send in
//                try await Task.sleep(nanoseconds: 700_000_000)
//                await send(.addNewRecord(record))
//            }
//            break
        }
    }
}
