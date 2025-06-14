//
//  AppStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import UIKit
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
        case completeSplash
        case completeOnboarding(MainRoute)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .completeSplash:
                if HistoryStateManager.shared.getOnboardingState() {
                    state.route = .onboarding
                } else {
                    return .run { send in
                        await send(.completeOnboarding(.main))
                    }
                }
                
            case .completeOnboarding(let mainRoute):
                var isRequestNotificationPermission = true
                var mainNavigationState = stateFactory.makeMainNavigationState()
                if mainRoute == .record {
                    let isComplete = HistoryStateManager.shared.getState()
                    let today = isComplete[.today, default: false]
                    let yesterday = isComplete[.yesterday, default: false]
                    if (!today || !yesterday) {
                        let context = RecordEntryPointStore.Context(today: today, yesterday: yesterday)
                        let state = stateFactory.makeRecordEntryPointState(context: context)
                        mainNavigationState.path.append(.record(state))
                        isRequestNotificationPermission = false
                        mainNavigationState.mainState.starBottleOpacity = 0.0
                    } else {
                        mainNavigationState.mainState.isPresentingAlreadyWrite = true
                    }
                }
                let mainNavigationStore = storeFactory.makeMainNavigationStore(state: mainNavigationState)
                UINavigationController.isBlockSwipe = false
                state.route = .main(mainNavigationStore)
                if isRequestNotificationPermission {
                    return .run { _ in
                        try await Task.sleep(nanoseconds: .nanosecondsPerSecond)
                        await NotificationManager().checkNotificationPermission()
                    }
                }
            }
            
            return .none
        }
    }
}
