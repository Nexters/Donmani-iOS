//
//  RecordNavigationStore+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture

extension RecordNavigationStore {    
    func runRecordAction(
        _ action: RecordEntryPointStore.Action.Delegate,
        _ state: inout RecordNavigationStore.State
    ) -> Effect<RecordNavigationStore.Action> {
//        switch action {
//        default:
//            
//        }
        return .none
    }
}
