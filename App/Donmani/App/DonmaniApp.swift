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
//    @State var isPresentingSplash: Bool = true
//    @State var rootType: RootType = .main
    
    var body: some Scene {
        WindowGroup {
            RootView()
//            if isPresentingSplash {
//                SplashView(isPresentingSplash: $isPresentingSplash)
//                    .onAppear {
//                        let rootType: RootType = HistoryStateManager.shared.getOnboardingState() ? .onboarding : .main
//                        let rootType: RootType = .onboarding
//                        self.rootType = rootType
//                        UINavigationController.rootType = rootType
//                    }
//            } else {
//                NavigationCoordinateView(
//                    store: Store(initialState: NavigationStore.State(rootType)) {
//                            NavigationStore()
//                        }
//                )
//            }
        }
    }
}
