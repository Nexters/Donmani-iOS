//
//  MainNavigationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import ComposableArchitecture

@Reducer
struct MainNavigationStore {
    
    @ObservableState
    struct State {
        var mainState: MainStore.State
        var path = StackState<Path.State>()
    }
    
    @Reducer
    enum Path {
        case main(MainStore)
        case setting
    }
    
    enum Action {
        case mainAction(MainStore.Action)
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(
            state: \.mainState,
            action: \.mainAction
        ) {
            MainStore()
        }
        
        Reduce { state, action in
            switch action {
            case .mainAction(let _):
                
            }
            return .none
        }
    }
}
