//
//  RewardReceiveView.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Lottie

struct RewardReceiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RewardReceiveStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center, spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                        .opacity(store.isPresentingBackButton ? 1.0 : 0.0)
                        Spacer()
                        
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                if store.isPresentingRewards {
                    RewardResultView()
                } else {
                    ReadyToReceiveReward()
                }
                
                DButton(
                    title: store.buttonTitle,
                    isEnabled: store.isEnabledButton
                ) {
                    store.send(.touchNextButton)
                }
                .padding(.defaultLayoutPadding)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    {
        let context = RewardReceiveStore.Context(rewardCount: 3)
        let state = MainStateFactory().makeRewardReceiveState(context: context)
        let store = MainStoreFactory().makeRewardReceiveStore(state: state)
        return RewardReceiveView(store: store)
    }()
}
