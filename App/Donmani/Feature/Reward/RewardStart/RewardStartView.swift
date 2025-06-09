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
                    .padding(-10)
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
                    
                    if !store.isEnabledButton {
                        VStack {
                            Spacer()
                            HStack(spacing: 4) {
                                DImage(.starShape).image
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(DColor(.pupleBlue90).color)
                                    .frame(width: 22)
                                DText("내일 다시 만나요!")
                                    .style(.b2, .semibold, .pupleBlue90)
                            }
                        }
                    }
                }
                
                if store.isFullReward {
                    VStack(spacing: 10) {
                        DButton(title: "후기 알려주기") {
                            store.send(.touchReviewButton)
                        }
                        .padding(.horizontal, .defaultLayoutPadding)
                        
                        Button {
                            dismiss()
                        } label: {
                            ZStack {
                                RoundedRectangle(
                                    cornerRadius: .s5,
                                    style: .continuous
                                )
                                .fill(DColor(.deepBlue50).color)
                                DText("홈으로")
                                    .style(.h3, .bold, .white)
                            }
                        }
                        .frame(height: 58)
                        .padding(.horizontal, .defaultLayoutPadding)
                        .padding(.bottom, .defaultLayoutPadding / 2)
                    }
                } else {
                    DButton(
                        title: store.buttonTitle,
                        isEnabled: store.isEnabledButton
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
        let context = RewardStartStore.Context(recordCount: 2, isNotOpened: true)
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 1, isNotOpened: true)
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 0, isNotOpened: false)
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}



