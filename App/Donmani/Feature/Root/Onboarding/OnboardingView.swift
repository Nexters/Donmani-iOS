//
//  OnboardingView.swift
//  Donmani
//
//  Created by 문종식 on 3/18/25.
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingStore>
    let completeHandler: ((RootStore.MainRoute) -> Void)?
    
    init(completeHandler: @escaping (RootStore.MainRoute) -> Void) {
        self.store = Store(
            initialState: OnboardingStore.State()
        ) {
            OnboardingStore()
        }
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        ZStack {
            DColor(.deepBlue20).color
                .ignoresSafeArea()
            switch store.step {
            case .cover:
                coverStepView
            case .page, .final:
                pageStepView
            }
        }
    }
}



#Preview {
    OnboardingView() { _ in }
}
