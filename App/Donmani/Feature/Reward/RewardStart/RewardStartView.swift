//
//  RewardStartView.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct RewardStartView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RewardStartStore>
    
    var body: some View {
        ZStack {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                    .background {
                        RewardBackground()
                    }
                    .padding(-5)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                        Spacer()
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                ZStack {
                    FeedbackStartView()
                    
                    if let feedbackCard = store.feedbackCard {
                        VStack {
                            FeedbackTitleView(feedbackCard: feedbackCard)
                                .padding(.defaultLayoutPadding)
                            Spacer()
                            FeedbackCardView(feedbackCard: feedbackCard)
                            Spacer()
                        }
                    }
                }
                
                DButton(
                    title: store.buttonTitle
                ) {
                    store.send(.touchNextButton)
                }
                .padding(.defaultLayoutPadding)
                .opacity(store.isPresentingButton ? 1 : 0)
                .animation(
                    .easeInOut(duration: 0.6),
                    value: store.isPresentingButton
                )
            }
            
            if store.isPresentingGuideBottomSheet {
                RewardGuideBottomSheet()
            }
        }
        .onAppear {
            store.send(.toggleGuideBottomSheet)
        }
        .navigationBarBackButtonHidden()
    }
    
    func RewardBackground() -> some View {
        ZStack {
            VStack {
                DImage(.rewardBackground).image
                    .resizable()
                    .scaledToFill()
                Spacer()
            }
        }
    }
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 0, rewardCount: 0)
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 5, rewardCount: 5)
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 5, rewardCount: 0)
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}



