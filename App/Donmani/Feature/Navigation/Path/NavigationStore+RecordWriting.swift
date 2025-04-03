//
//  NavigationStore+RecordEntryPoint.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension NavigationStore {
    func recordWritingDelegateAction(
        id: StackElementID,
        state: inout NavigationStore.State,
        action: RecordWritingStore.Action.Delegate
    ) -> Effect<NavigationStore.Action> {
        switch action {
        case .popToRecordEntrypointView:
            state.path.removeLast()
            return .none
            
        case .popToRecordEntrypointViewWith(let content):
            var recordEntrypointViewID: StackElementID?
            for (id, element) in zip(state.path.ids, state.path) {
                switch element {
                case .recordEntryPoint:
                    recordEntrypointViewID = id
                default:
                    break
                }
            }
            //            state.updateRecordContent(content)
            if let recordEntrypointViewID = recordEntrypointViewID {
                if case .recordEntryPoint(var recordEntryPointState) = state.path[id: recordEntrypointViewID] {
                    switch content.flag {
                    case .good:
                        recordEntryPointState.goodRecord = content
                    case .bad:
                        recordEntryPointState.badRecord = content
                    }
                    let isSaveEnabled = !(recordEntryPointState.badRecord == nil && recordEntryPointState.goodRecord == nil)
                    recordEntryPointState.isSaveEnabled = isSaveEnabled
                    UINavigationController.swipeNavigationPopIsEnabled = false
                    state.path[id: recordEntrypointViewID] = .recordEntryPoint(recordEntryPointState)
                }
            }
            state.path.removeLast()
            return .none
        }
    }
}
