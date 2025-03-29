//
//  NavigationStore+Extention.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture

extension NavigationStore {
    func path(
        state: inout NavigationStore.State,
        pathElement: StackActionOf<NavigationStore.Path>
    ) -> Effect<NavigationStore.Action> {
        switch pathElement {
        case .element(id: let id, action: let action):
            switch action {
            case .main(.delegate(let mainAction)):
                return mainDelegateAction(state: &state, action: mainAction)
            case .bottleList(.delegate(let bottleListAction)):
                return bottleListDelegateAction(id: id, state: &state, action: bottleListAction)
            case .recordList(.delegate(let recordListAction)):
                return recordListDelegateAction(id: id, state: &state, action: recordListAction)
            case .recordEntryPoint(.delegate(let recordEntryPointAction)):
                return recordEntryPointDelegateAction(id: id, state: &state, action: recordEntryPointAction)
            case .recordWriting(.delegate(let recordWritingAction)):
                return recordWritingDelegateAction(id: id, state: &state, action: recordWritingAction)
            case .statistics(_):
                return .none
            case .setting:
                return .none
            default:
                return .none
            }
        default:
            return .none
        }
    }
}


