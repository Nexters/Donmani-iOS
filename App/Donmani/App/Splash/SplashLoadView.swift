//
//  SplashLoadView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem
import DNetwork
import ComposableArchitecture

struct SplashLoadView: View {
    @State var navigationPath = NavigationPath()
    @State var isLoading: Bool = true
    @State var isLatestVersion: Bool = false
    
    var body: some View {
        if isLoading {
            SplashView()
                .onAppear {
//                    let k = KeychainManager()
//                    k.deleteToKeychain(to: .uuid)
//                    k.deleteToKeychain(to: .name)
                    loadData()
                }
        } else {
            NavigationStack(path: $navigationPath) {
                MainView(
                    store: Store(initialState: MainStore.State(
                        isLatestVersion: isLatestVersion
                    )) {
                        MainStore()
                    }
                )
            }
        }
    }
}

#Preview {
    SplashLoadView()
}
