//
//  OnboardingView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/18/25.
//

import SwiftUI
import DesignSystem

extension OnboardingView {
    var coverStepView: some View {
        VStack(alignment: .center) {
            VStack(spacing: 20) {
                DText("안녕! 별별소에 온 걸 환영해")
                    .style(.h1, .bold, .white)
                    .multilineTextAlignment(.center)
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.5),
                                    DColor(.deepBlue20).color
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                    DImage(.starShape).image
                        .resizable()
                        .frame(width: .s4 * 3, height: .s4 * 3)
                }
                
                DText("금액이 아닌 의미를 고민하며\n너의 소비가 남긴 감정을 돌아보러 가볼까?")
                    .style(.h3, .regular, .gray60)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            
            Spacer()
            VStack(spacing: 0) {
                DImage(.onboardingCover).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: .screenWidth * 0.4)
                    .offset(x: 0.0, y: 0.0)
                
                DButton(title: "별별소 알아보기") {
                    GA.Click(event: .onboardingStartButton).send()
                    store.send(.touchStartOnboarding)
                }
            }
        }
        .padding(.bottom, .s5 / 2)
        .padding(.top, 80)
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    var pageStepView: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    ForEach(0..<store.guidePageCount, id: \.self) { i in
                        Circle()
                            .fill(.white.opacity(i == store.pageIndex ? 1.0 : 0.1))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.top, 50)
                .padding(.bottom, .s4)
                
                TabView(selection: $store.pageIndex) {
                    ForEach(0..<store.guidePageCount, id: \.self) { i in
                        PageGuideView(index: i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Group {
                    if store.step == .page {
                        DButton(title: "다음") {
                            store.send(.touchNextPage, animation: .linear)
                        }
                    } else {
                        HStack {
                            Button {
                                GA.Click(event: .onboardingHomeButton).send()
                                store.send(.touchFinalButton(.main))
                            } label: {
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: 16.0,
                                        style: .continuous
                                    )
                                    .fill(DColor(.deepBlue50).color)
                                    .frame(height: 58)
                                    DText("홈으로")
                                        .style(.h3, .bold, .white)
                                }
                            }
                            DButton(title: "기록해 보기") {
                                GA.Click(event: .onboardingRecordButton).send()
                                store.send(.touchFinalButton(.record))
                            }
                        }
                    }
                }
                .padding(.bottom, .s5 / 2)
                .padding(.horizontal, .defaultLayoutPadding)
            }
            if store.isPresentingEndOnboardingView {
                OnboardingEndView()
            }
        }
    }
    
    func PageGuideView(index: Int) -> some View {
        VStack {
            GuideText(
                title: store.guideTitles[index],
                content: store.guideContents[index]
            )
            Spacer()
            DImage(store.guideImageAssets[index]).image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding(.bottom, store.guideBottomPadding[index])
    }
    
    func GuideText(
        title: String,
        content: String
    ) -> some View {
        VStack(spacing: .s3) {
            DText(title)
                .style(.h1, .bold, .white)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            DText(content)
                .style(.h3, .regular, .gray60)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    func GuideImage(_ imageAsset: DImageAsset) -> some View {
        DImage(imageAsset).image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: .screenWidth)
    }
}
