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
        case .popToMainView:
            if state.rootType == .onboarding {
                if let mainViewID = state.path.ids.first {
                    state.path.pop(to: mainViewID)
                }
            } else {
                state.path.removeAll()
            }
            return .none
            
        case .popToMainViewWith(let record):
            if state.rootType == .onboarding {
                if let mainViewID = state.path.ids.first {
                    state.path.pop(to: mainViewID)
                }
            } else {
                state.path.removeAll()
            }
            return .run { send in
                await send(.addNewRecord(record))
            }
        
//        case .pushRecordWritingViewWith(let content):
//            state.recordWritingState = RecordWritingStore.State(type: content.flag, content: content)
//            state.path.append(.recordWriting(state.recordWritingState))
//            return .none
//            
//        case .pushRecordWritingView(let type):
//            state.recordWritingState = RecordWritingStore.State(type: type)
//            state.path.append(.recordWriting(state.recordWritingState))
//            return .none
        }
    }
}
