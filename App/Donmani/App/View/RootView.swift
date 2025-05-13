//
//  RootView.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var store: StoreOf<RootStore>
    
    init() {
        self.store = Store(
            initialState: RootStore.State()
        ) {
            RootStore()
        }
    }
    
    var body: some View {
        ZStack {
            switch store.route {
            case .splash:
                SplashView {
                    store.send(.presentOnboarding)
                }
                .transition(.opacity)
                .id("splash")
            case .onboarding:
                OnboardingView { confirmType in
                    store.send(.onboardingCompleted(confirmType))
                }
                .transition(.opacity)
                .id("onboarding")
            case .main(let mainStore):
                MainView(store: mainStore)
                    .transition(.move(edge: .trailing))
                    .id("main")
            }
        }
        .animation(.smooth, value: store.route)
    }
}

#Preview {
    RootView()
}
