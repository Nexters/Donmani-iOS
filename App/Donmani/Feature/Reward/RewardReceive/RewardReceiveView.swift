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
            VStack(alignment: .center, spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        DNavigationBarButton(.arrowLeft) {
                            store.send(.delegate(.popToRoot))
                        }
                        .opacity(store.isPresentingBackButton ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.3), value: store.isPresentingBackButton)
                        Spacer()
                        
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                if store.isPresentingRewardsBox {
                    ReadyToReceiveReward()
                }
                if store.isPresentingRewards {
                    RewardResultView()
                }
                
                DButton(
                    title: store.buttonTitle
                ) {
                    store.send(.touchNextButton)
                }
                .opacity(store.isPresentingBackButton ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.3), value: store.isPresentingBackButton)
                .padding(.defaultLayoutPadding)
            }
        }
        .onAppear {
            GA.View(event: .reward).send()
        }
        .navigationBarBackButtonHidden()
        .background {
            BackgroundView()
        }
    }
}

#Preview {
    {
        let context = RewardReceiveStore.Context(rewardCount: 2)
        let state = MainStateFactory().makeRewardReceiveState(context: context)
        let store = MainStoreFactory().makeRewardReceiveStore(state: state)
        return RewardReceiveView(store: store)
    }()
}
