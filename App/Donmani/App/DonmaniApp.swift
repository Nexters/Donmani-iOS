//
//  DonmaniApp.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct DonmaniApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isPresentingSplash: Bool = true
    @State var rootType: RootType = .onboarding //HistoryStateManager.shared.getOnboardingState() ? .onboarding : .main
    
    var body: some Scene {
        WindowGroup {
            if isPresentingSplash {
                SplashView(isPresentingSplash: $isPresentingSplash)
            } else {
                NavigationCoordinateView(
                    store: Store(initialState: NavigationStore.State(rootType)) {
                            NavigationStore()
                        }
                )
            }
        }
    }
}
