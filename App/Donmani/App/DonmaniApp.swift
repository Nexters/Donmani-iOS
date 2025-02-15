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
    @State var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                MainView(
                    store: Store(initialState: MainStore.State()) {
                        MainStore()
                    }
                )
            }
        }
    }
}
