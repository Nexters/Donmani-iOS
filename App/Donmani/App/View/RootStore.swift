//
//  AppStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import ComposableArchitecture

@Reducer
struct RootStore {
    @Dependency(\.mainStoreFactory) var storeFactory
    @Dependency(\.mainStateFactory) var stateFactory
    
    enum MainRoute {
        case main
        case record
    }
    
    enum AppRoute: Equatable {
        case splash
        case onboarding
        case main(StoreOf<MainNavigationStore>)
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
                let mainNavigationState = stateFactory.makeMainNavigationState()
                let mainNavigationStore = storeFactory.makeMainNavigationStore(state: mainNavigationState)
                state.route = .main(mainNavigationStore)
            }
            
            return .none
        }
    }
}
