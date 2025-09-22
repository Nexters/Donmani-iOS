//
//  RootView.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct RootView: View {
    @Bindable var store: StoreOf<RootStore>
    
    init() {
        self.store = Store(initialState: RootStore.State()) {
            RootStore()
        }
    }
    
    var body: some View {
        ZStack {
            ZStack {
                switch store.route {
                case .onboarding:
                    OnboardingView { confirmType in
                        store.send(.completeOnboarding(confirmType))
                    }
                    .id(store.route.id)
                    
                case .main(let mainStore):
                    MainNavigationView(
                        store: mainStore
                    )
                    .transition(.move(edge: .trailing))
                    .id(store.route.id)
                    
                case .splash:
                    SplashView {
                        store.send(.completeSplash)
                    }
                    .transition(.opacity)
                    .id(store.route.id)
                }
            }
            .animation(.smooth, value: store.route)
            .background {
                BackgroundView(colors: [
                    DColor.backgroundTop,
                    DColor.backgroundBottom,
                ])
            }
            
            ToastView()
        }
        
    }
}

#Preview {
    RootView()
}
