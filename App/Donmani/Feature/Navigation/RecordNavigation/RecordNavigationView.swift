//
//  RecordNavigationView.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import SwiftUI
import ComposableArchitecture

struct RecordNavigationView: View {
    @Bindable var store: StoreOf<RecordNavigationStore>
    let completeHandler: ((Record) -> Void)?
    
    init(
        store: StoreOf<RecordNavigationStore>,
        completeHandler: @escaping (Record) -> Void
    ) {
        self.store = store
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            RecordEntryPointView(
                store: store.scope(
                    state: \.recordState,
                    action: \.recordAction
                )
            ) { record in
                completeHandler?(record)
            }
        } destination: { store in
            switch store.case {
            case .recordWrite(let store):
                RecordWritingView(store: store)
            }
        }
    }
}

#Preview {
    {
        let context = RecordEntryPointStore.Context(today: true, yesterday: true)
        let state = MainStateFactory().makeRecordNavigationState(context: context)
        let store = MainStoreFactory().makeRecordNavigationStore(state: state)
        return RecordNavigationView(store: store) { _ in }
    }()
}
