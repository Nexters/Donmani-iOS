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
    @State var isLatestVersion: Bool = true
    
    var body: some View {
        if isLoading {
            SplashView()
                .onAppear {
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

//extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}
