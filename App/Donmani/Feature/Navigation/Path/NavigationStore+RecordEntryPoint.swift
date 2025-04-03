//
//  NavigationStore+RecordEntryPoint.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension NavigationStore {
    func recordEntryPointDelegateAction(
        id: StackElementID,
        state: inout NavigationStore.State,
        action: RecordEntryPointStore.Action.Delegate
    ) -> Effect<NavigationStore.Action> {
        switch action {
        case .pushRecordWritingViewWith(let content):
            state.recordWritingState = RecordWritingStore.State(type: content.flag, content: content)
            UINavigationController.swipeNavigationPopIsEnabled = true
            state.path.append(.recordWriting(state.recordWritingState))
            return .none
            
        case .pushRecordWritingView(let type):
            state.recordWritingState = RecordWritingStore.State(type: type)
            UINavigationController.swipeNavigationPopIsEnabled = true
            state.path.append(.recordWriting(state.recordWritingState))
            return .none
            
        case .popToMainView(let record):
            if state.rootType == .onboarding {
                if let mainViewID = state.path.ids.first {
                    if case .main(var mainState) = state.path[id: mainViewID] {
                        mainState.isRequestNotificationPermission = true
                        state.path[id: mainViewID] = .main(mainState)
                        state.path.pop(to: mainViewID)
                    }
                }
            } else {
                state.path.removeAll()
                state.mainState.isRequestNotificationPermission = true
            }
            NotificationManager().checkNotificationPermission()
            if let record = record {
                return .run { send in
                    await send(.addNewRecord(record))
                }
            } else {
                return .none
            }
        }
    }
}
