//
//  NavigationCoordinateView.swift
//  Donmani
//
//  Created by 문종식 on 3/19/25.
//

import SwiftUI
import ComposableArchitecture

struct NavigationCoordinateView: View {
    @Bindable var store: StoreOf<NavigationStore>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            switch store.rootType {
            case .main:
                MainView(store: store.scope(state: \.mainState, action: \.mainAction))
            case .onboarding:
                OnboardingView(store: store.scope(state: \.onboardingState, action: \.onboardingAction))
            }
        } destination: { store in
            switch store.case {
            case .main(let store):
                MainView(store: store)
            case .recordEntryPoint(let store):
                RecordEntryPointView(store: store)
            case .recordList(let store):
                RecordListView(store: store)
            case .recordWriting(let store):
                RecordWritingView(store: store)
            case .bottleList(let store):
                BottleListView(store: store)
            case .monthlyStarBottle(let store):
                MonthlyStarBottleView(store: store)
            case .statistics(let store):
                StatisticsView(store: store)
            case .setting:
                SettingView()
            }
        }
        .onAppear {
            UINavigationController.store = store
        }
    }
}

#Preview {
    NavigationCoordinateView(
        store: Store(initialState: NavigationStore.State(.onboarding)) {
            NavigationStore()
        }
    )
}

#Preview {
    NavigationCoordinateView(
        store: Store(initialState: NavigationStore.State(.main)) {
            NavigationStore()
        }
    )
}
