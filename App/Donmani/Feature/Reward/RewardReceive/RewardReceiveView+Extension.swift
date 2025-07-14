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
                DText("열지 않은 선물 \(store.rewardCount - 1)개 함께 열게요")
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
                            .padding(.horizontal, .defaultLayoutPadding * 3)
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
                // Rewards
                RewardItemListView()
                    .scaleEffect(store.isPresentingRewards ? 1 : 0.01, anchor: .center)
                    .opacity(store.isPresentingRewards ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: store.isPresentingRewards)
                
                // Confetti
                VStack {
                    Spacer()
                    LottieView(animation: store.confettiLottieAnimation)
                        .playing(loopMode: .playOnce)
                        .animationDidFinish { _ in
                            store.send(.dismissLottie)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                    Spacer()
                }
                .opacity(store.isPlayingLottie ? 1.0 : 0.0)
                .allowsHitTesting(false)
            }
        }
    }
    
    func RewardItemListView() -> some View {
        ZStack {
            TabView(selection: $store.rewardIndex) {
                ForEach(0..<store.rewardCount, id: \.self) { i in
                    ZStack {
                        VStack {
                            Spacer()
                            RewardItemListCardView(item: store.rewardItems[i])
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                {
                                    let name = store.rewardItems[i].name
                                    let particle = name.hasFinalConsonant ? "을" : "를"
                                    return DText( "\(name)\(particle) 받았어요!")
                                        .style(.h2, .bold, .deepBlue99)
                                }()
                                Spacer()
                            }
                            .padding(.defaultLayoutPadding)
                            Spacer()
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            if (store.rewardCount > 1) {
                VStack {
                    Spacer()
                    InstagramIndicator(
                        count: store.rewardCount,
                        current: store.rewardIndex
                    )
                    .allowsHitTesting(false)
                    .padding(.top, .screenWidth * (8/15) + .defaultLayoutPadding * 2)
                    Spacer()
                }
            }
        }
    }
                    
    func RewardItemListCardView(item: Reward) -> some View {
        let mapper = RewardResourceMapper(id: item.id, category: item.category)
        var image = mapper.image().image
        if item.category == .byeoltong {
            image = mapper.image(isPreview: true).image
        }
        let size = CGFloat.screenWidth * (8/15)
        return VStack {
            if (item.category == .background) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(DColor(.deepBlue60).color)
                    .frame(width: size, height: size)
                    .overlay {
                        image
                            .resizable()
                            .padding(20)
                    }
            }
        }
    }
}

struct InstagramIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        let indicators = indicatorIndexes()
        HStack(spacing: 6) {
            ForEach(indicators, id: \.self) { idx in
                Circle()
                    .fill(.white.opacity(idx == current ? 1.0 : 0.1))
                    .frame(width: indicatorSize(idx), height: indicatorSize(idx))
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
    }
    
    private func indicatorIndexes() -> [Int] {
        if count <= 5 { return Array(0..<count) }
        let start = max(0, min(current - 2, count - 5))
        return Array(start..<start+5)
    }
    
    private func indicatorSize(_ idx: Int) -> CGFloat {
        if idx == current { return 6 }
        if abs(idx - current) == 1 { return 6 }
        if abs(idx - current) == 2 { return 4 }
        return 3
    }
}
