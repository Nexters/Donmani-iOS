//
//  RewardStartView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import SwiftUI
import DesignSystem


extension RewardStartView {
    func FeedbackStartView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: .s5) {
                    DText(store.title)
                        .style(.h2, .bold, .deepBlue99)
                        .lineSpacing(4)
                    DText(store.subtitle)
                        .style(.b2, .regular, .deepBlue90)
                }
                Spacer()
            }
            .padding(.defaultLayoutPadding)
            
            Spacer()
            
            if store.isFullReward {
                DImage(.fullRewardCharacter).image
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, -.s5 / 2.0)
            } else {
                DImage(.rewardCharacter).image
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, -.s5 / 2.0)
            }
        }
        .opacity(store.isPresentingFeedbackStartView ? 1 : 0)
        .animation(.easeInOut(duration: 0.6), value: store.isPresentingFeedbackStartView)
    }
    
    func FeedbackTitleView(feedbackCard: FeedbackCard) -> some View {
        VStack(alignment: .leading, spacing: .s5 / 2.0) {
            DText(store.userName + "님,")
                .style(.h2, .bold, .deepBlue99)
            HStack(alignment: .center, spacing: .s5 / 2.0) {
                DText(store.dayTitle)
                    .style(.h2, .bold, .deepBlue99)
                DText(feedbackCard.category?.title ?? "무소비")
                    .style(.h2, .bold, .deepBlue99)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8.0, style: .circular)
                            .fill(Color.white.opacity(0.1))
                    }
                DText((feedbackCard.category == nil ? "" : "소비를 ") + "했네요!").style(.h2, .bold, .deepBlue99)
                Spacer()
            }
        }
        .opacity(store.isPresentingFeedbackTitle ? 1 : 0)
        .offset(y: store.isPresentingFeedbackTitle ? -5 : 0)
        .animation(.easeInOut(duration: 0.5), value: store.isPresentingFeedbackTitle)
    }
    
    func FeedbackCardView(feedbackCard: FeedbackCard) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .s1, style: .circular)
                .fill((feedbackCard.category?.color ?? DColor.emptyColor).opacity(0.5))
            RoundedRectangle(
                cornerRadius: .s1,
                style: .continuous
            )
            .strokeBorder(.white.opacity(0.2), lineWidth: 2)
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    HStack(alignment: .center, spacing: 10) {
                        DImage(.smallStar)
                            .image
                            .resizable()
                            .frame(width: 12, height: 12)
                            .opacity(0.2)
                        DText("토비의 한마디")
                            .style(.b3, .bold, .deepBlue99)
                        DImage(.smallStar)
                            .image
                            .resizable()
                            .frame(width: 12, height: 12)
                            .opacity(0.2)
                    }
                    .padding(.s5 / 2.0)
                    .background {
                        Capsule(style: .circular)
                            .fill(Color.black.opacity(0.2))
                    }
                    Spacer()
                }
                .frame(height: .s2)
                .padding(.bottom, 40)
                
                (feedbackCard.category?.image ?? DImage(.noneSticker).image)
                    .resizable()
                    .frame(width: 78, height: 78)
                
                DText(feedbackCard.title)
                    .style(.h2, .bold, .white)
                    .padding(.bottom, 10)
                DText(feedbackCard.content+"\n")
                    .style(.b2, .regular, .gray95)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 36.5)
            .padding(.top, 30)
            .padding(.bottom, 60)
        }
        .frame(width: .screenWidth * (52.0/75.0), height: .screenWidth * (14.0/15.0))
        .opacity(store.isPresentingFeedbackCard ? 1 : 0)
        .offset(y: store.isPresentingFeedbackCard ? -5 : 0)
        .animation(.easeInOut(duration: 0.5), value: store.isPresentingFeedbackCard)
    }
}
