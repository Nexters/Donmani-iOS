//
//  RewardStartView.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import DNetwork

struct RewardStartView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RewardStartStore>
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                DNavigationBar(
                    leading: {
                        DNavigationBarButton(.arrowLeft) {
                            dismiss()
                        }
                    }
                )
                
                ZStack {
                    FeedbackStartView()
                    if let feedbackCard = store.feedbackCard {
                        VStack {
                            FeedbackTitleView(feedbackCard: feedbackCard)
                                .padding(.defaultLayoutPadding)
                            Spacer()
                            FeedbackCardView(feedbackCard: feedbackCard)
                                .onAppear {
                                    GA.View(event: .feedback).send()
                                }
                            Spacer()
                        }
                    }
                    
                    if !store.isEnabledButton && !store.isFullReward {
                        VStack {
                            Spacer()
                            HStack(spacing: 4) {
                                DImage(.starShape).image
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(DColor(.purpleBlue90).color)
                                    .frame(width: 22)
                                DText("내일 다시 만나요!")
                                    .style(.b2, .semibold, .purpleBlue90)
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
                            store.send(.touchDecorationButton)
                        } label: {
                            ZStack {
                                RoundedRectangle(
                                    cornerRadius: .s5,
                                    style: .continuous
                                )
                                .fill(DColor(.deepBlue50).color)
                                DText("받은 선물 꾸며보기")
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
        .sheet(isPresented: $store.isPresentingRewardFeedbackView) {
            InnerWebView(urlString: DURL.rewardFeedback.urlString)
        }
        .onAppear {
            store.send(.toggleGuideBottomSheet)
            GA.View(event: .received).send()
        }
        .navigationBarBackButtonHidden()
        .background {
            RewardBackground()
                .ignoresSafeArea()
                .padding(-10)
        }
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
        let context = RewardStartStore.Context(recordCount: 2, isNotOpened: true, userName: "")
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 1, isNotOpened: true, userName: "")
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}

#Preview {
    {
        let context = RewardStartStore.Context(recordCount: 0, isNotOpened: false, userName: "")
        let state = MainStateFactory().makeRewardStartState(context: context)
        let store = MainStoreFactory().makeRewardStartStore(state: state)
        return RewardStartView(store: store)
    }()
}



