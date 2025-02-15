//
//  RecordListStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import ComposableArchitecture

@Reducer
struct RecordListStore {
    
    // MARK: - State
    @ObservableState
    struct State {
        
    }
    
    // MARK: - Action
    enum Action {
        
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
