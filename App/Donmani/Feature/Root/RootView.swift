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
            SplashView {
                store.send(.completeSplash)
            }
            .id("splash")
            switch store.route {
            case .onboarding:
                OnboardingView { confirmType in
                    store.send(.completeOnboarding(confirmType))
                }
                .id("onboarding")
                
            case .main(let store):
                MainNavigationView(store: store)
                    .transition(.move(edge: .trailing))
                    .id("main")
            case .splash:
                Spacer()
            }
        }
        .animation(.smooth, value: store.route)
    }
}

#Preview {
    RootView()
}
