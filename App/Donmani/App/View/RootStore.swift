//
//  AppStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import ComposableArchitecture

@Reducer
struct RootStore {
    
    enum MainRoute {
        case main
        case record
    }
    
    enum AppRoute: Equatable {
        case splash
        case onboarding
        case main(StoreOf<MainStore>)
    }
    
    @ObservableState
    struct State {
        var route: AppRoute = .splash
    }
    
    
    enum Action {
        case presentOnboarding
        case onboardingCompleted(MainRoute)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .presentOnboarding:
                state.route = .onboarding
                
            case .onboardingCompleted(let mainRoute):
                let mainStore = Store(initialState: MainStore.State()) { MainStore() }
                state.route = .main(mainStore)
            }
            
            return .none
        }
    }
}
