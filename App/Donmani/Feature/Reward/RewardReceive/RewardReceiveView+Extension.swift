//
//  RewardReceiveView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import DesignSystem
import Lottie

extension RewardReceiveView {
    func MultiRewardGuideText() -> some View {
        HStack(alignment: .top, spacing: .s5 / 2) {
            VStack {
                DImage(.notice).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
            }
            VStack(alignment: .leading, spacing: .s5 / 2.0) {
                DText("열지 않은 선물 \(store.rewardCount)개 함께 열게요")
                    .style(.b1, .semibold, .gray99)
                DText("이벤트 기간동안 기록 할 때마다 선물 받아요")
                    .style(.b2, .regular, .gray99)
            }
            .padding(.top, 2)
            Spacer()
        }
        .padding(.s5)
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    func ReadyToReceiveReward() -> some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        DText(store.title)
                            .style(.h2, .bold, .deepBlue99)
                        Spacer()
                    }
                    .padding(.defaultLayoutPadding)
                    
                    Spacer()
                    VStack(alignment: .center) {
                        Spacer()
                        if store.isPresentMultiRewardGuideText {
                            MultiRewardGuideText()
                        }
                    }
                }
                .opacity(store.isPresentingMainTitle ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: store.isPresentingMainTitle)
                
                VStack {
                    Spacer()
                    if store.isPresentDefaultLottieView {
                        LottieView(animation: store.defaultLottieAnimation)
                            .playing(loopMode: .loop)
                            .aspectRatio(1.0, contentMode: .fit)
                            .padding(.horizontal, .defaultLayoutPadding * 2)
                            .scaleEffect(store.isPresentingMainImage ? 1 : 0.01, anchor: .center)
                            .opacity(store.isPresentingMainImage ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: store.isPresentingMainImage)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func RewardResultView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        DText(store.rewardTitle)
                            .style(.h2, .bold, .deepBlue99)
                        Spacer()
                    }
                    .padding(.defaultLayoutPadding)
                    
                    Spacer()
                }
                .opacity(store.isPresentingRewardTitle ? 1 : 0)
                .offset(y: store.isPresentingRewardTitle ? -5 : 0)
                .animation(.easeInOut(duration: 0.3), value: store.isPresentingRewardTitle)
                
                // Rewards
                VStack {
                    Spacer()
                        .layoutPriority(2)
                    RewardItemListView()
                        .scaleEffect(store.isPresentingRewards ? 1 : 0.01, anchor: .center)
                        .opacity(store.isPresentingRewards ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: store.isPresentingRewards)
                        .layoutPriority(1)
                    Spacer()
                        .layoutPriority(2)
                }
                
                // Confetti
                VStack {
                    Spacer()
                    LottieView(animation: store.confettiLottieAnimation)
                        .playing(loopMode: .playOnce)
                        .animationDidFinish { _ in
                            store.send(.dismissLottie)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .padding(.horizontal, .defaultLayoutPadding * 2)
                    Spacer()
                }
                .opacity(store.isPlayingLottie ? 1.0 : 0.0)
            }
        }
    }
    
    func RewardItemListView() -> some View {
        TabView(selection: $store.rewardIndex) {
            ForEach(0..<store.rewardCount, id: \.self) { i in
                DImage(.defaultGoodSticker).image
                    .frame(width: .screenWidth * (8/15), height: .screenWidth * (8/15))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(minHeight: .screenWidth * (8/15) + 50)
    
    }
}

