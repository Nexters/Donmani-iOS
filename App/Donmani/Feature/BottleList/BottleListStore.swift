//
//  BottleListStore.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import ComposableArchitecture

@Reducer
struct BottleListStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var isPresentingTopBanner: Bool
        
        init() {
            self.isPresentingTopBanner = HistoryStateManager.shared.getMonthlyBottleGuide()
        }

    }
    
    // MARK: - Action
    enum Action {
        case closeTopBanner

    }
    
    // MARK: - Dependency
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTopBanner:
                state.isPresentingTopBanner = false
                HistoryStateManager.shared.setMonthlyBottleGuide()
                return .none
            }
        }
    }
}
