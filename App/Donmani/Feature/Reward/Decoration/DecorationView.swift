//
//  DecorationView.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Lottie

struct DecorationView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<DecorationStore>
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if let backgroud = store.selectedDecorationItem[.background] {
                        Color.clear
                            .ignoresSafeArea()
                            .background {
                                RewardResourceMapper(
                                    id: backgroud.id,
                                    category: .background
                                )
                                .image(isPreview: true)
                                .image
                                .resizable()
                                .scaledToFill() 
                                .ignoresSafeArea()
                                .padding(-5)
                            }
                    }
                    
                    if let effect = store.selectedDecorationItem[.effect] {
                        let lottieName = RewardResourceMapper(id: effect.id, category: .effect).resource()
                        if !lottieName.isEmpty {
                            GeometryReader { proxy in
                                DLottieView(
                                    name: lottieName,
                                    loopMode: .loop
                                )
                                .frame(
                                    width: proxy.size.width,
                                    height: .screenHeight
                                )
                                .ignoresSafeArea()
                            }
                            .allowsHitTesting(false)
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        // Navigation Bar
                        ZStack {
                            HStack {
                                Spacer()
                                DText("꾸미기")
                                    .style(.b1, .semibold, .white)
                                Spacer()
                            }
                            HStack {
                                DNavigationBarButton(.leftArrow) {
                                    store.send(.touchBackButton)
                                }
                                Spacer()
                                Button {
                                    store.send(.touchSaveButton)
                                } label: {
                                    DText("완료")
                                        .style(.b1, .semibold,
                                               store.disabledSaveButton
                                               ? .white.opacity(0.4)
                                               : .white
                                        )
                                        .frame(height: .s3)
                                }
                                .disabled(store.disabledSaveButton)
                            }
                        }
                        .frame(height: .navigationBarHeight)
                        .padding(.horizontal, .defaultLayoutPadding)
                        
                        Spacer()
                        
                        ZStack {
                            DImage(.byeoltongBackground).image
                                .resizable()
                                .frame(width: .screenWidth * 0.8)
                                .aspectRatio(0.8, contentMode: .fit)
                            
                            ZStack {
                                StarBottleView(
                                    size: .screenWidth * 0.7,
                                    records: store.monthlyRecords,
                                    backgroundShape: $store.byeoltongShapeType
                                )
                                .aspectRatio(0.8, contentMode: .fit)
                                .frame(width: .screenWidth * 0.7)
                                
                                DImage(store.byeoltongImageType).image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .screenWidth * 0.7)
                            }
                        }
                        .padding(.vertical, .defaultLayoutPadding * 2)
                        .overlay {
                            if let decoration = store.selectedDecorationItem[.decoration] {
                                let lottieName = RewardResourceMapper(id: decoration.id, category: .decoration).resource()
                                if !lottieName.isEmpty {
                                    if decoration.id == 23 {
                                        VStack {
                                            HStack {
                                                DImage(.rewardDecorationSpaceVacance)
                                                    .image
                                                    .resizable()
                                                    .aspectRatio(0.67, contentMode: .fit)
                                                    .frame(height: .screenWidth * 0.27)
                                                    .offset(
                                                        x: (store.byeoltongShapeType == .rewardBottleDefaultShape
                                                            ||
                                                            store.byeoltongShapeType == .rewardBottleFuzzyShape)
                                                        ? .screenWidth * 0.15
                                                        : 0,
                                                        y: store.byeoltongShapeType == .rewardBottleDefaultShape
                                                        ? -25
                                                        : (store.byeoltongShapeType == .rewardBottleFuzzyShape
                                                        ? +20
                                                        : -20)
                                                    )
                                            }
                                            Spacer()
                                        }
                                    } else {
                                        if decoration.id == 20 {
                                            VStack {
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    DLottieView(
                                                        name: lottieName,
                                                        loopMode: .loop
                                                    )
                                                    .frame(width: 80, height: 80)
                                                }
                                            }
                                            .allowsHitTesting(false)
                                        } else {
                                            VStack {
                                                HStack {
                                                    DLottieView(
                                                        name: lottieName,
                                                        loopMode: .loop
                                                    )
                                                    .frame(width: 80, height: 80)
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .allowsHitTesting(false)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    

                }
                .frame(width: .screenWidth)
                
                VStack {
                    HStack(spacing: .s4) {
                        ForEach(
                            RewardItemCategory.cases,
                            id: \.self
                        ) { item in
                            Button {
                                store.send(.touchRewardItemCategoryButton(item))
                            } label: {
                                if (store.selectedRewardItemCategory == item) {
                                    DText(item.title)
                                        .style(.b1, .bold, Color.white)
                                } else {
                                    DText(item.title)
                                        .style(.b1, .bold, .deepBlue80)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, .defaultLayoutPadding)
                    .padding(.top, .s5)
                    
                    if store.itemList.isEmpty {
                        Spacer()
                        EmptyItemListView()
                        Spacer()
                    } else {
                        ItemGridView(itemCategory: store.selectedRewardItemCategory)
                        Spacer()
//                        if store.selectedRewardItemCategory == .sound {
//                            HStack{
//                                DText("・휴대폰을 흔들면 효과음이 들려요 🎹")
//                                    .style(.b2, .medium, .deepBlue90)
//                                Spacer()
//                            }
//                            .padding(.horizontal, .defaultLayoutPadding)
//                            .padding(.bottom, .defaultLayoutPadding)
//                        }
                    }
                }
                .frame(height: .screenHeight * 0.4)
                .background(DColor(.deepBlue60).color)
            }
            
//            if store.selectedRewardItemCategory == .sound {
//                EqualizerButton()
//            }
            
            if store.isPresentingGuideBottomSheet {
                DecorationGuideBottomSheet()
            }
            
            if store.isPresentingFinalBottomSheet {
                DecorationFullBottomSheet()
                LottieView(animation: store.confettiLottieAnimation)
                    .playing(loopMode: .playOnce)
                    .aspectRatio(1.0, contentMode: .fit)
            }
            
            if store.isPresentingDecorationGuideAlert {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    VStack(spacing: .s4) {
                        DText("설정 > 꾸미기에서\n언제든 바꿀 수 있어요")
                            .style(.h2, .bold, .deepBlue99)
                            .lineSpacing(8)
                            .multilineTextAlignment(.center)
                        HStack(spacing: 10) {
                            Button {
                                store.send(.cancelSave)
                            } label: {
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: .s1 / 2,
                                        style: .continuous
                                    )
                                    .fill(DColor(.deepBlue50).color)
                                    .frame(height: 58)
                                    DText("돌아가기")
                                        .style(.h3, .bold, .white)
                                }
                            }
                            
                            Button {
                                store.send(.saveDecorationItem)
                            } label: {
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: .s1 / 2,
                                        style: .continuous
                                    )
                                    .fill(DColor(.gray95).color)
                                    .frame(height: 58)
                                    DText("저장하기")
                                        .style(.h3, .bold, .deepBlue20)
                                }
                            }
                        }
                    }
                    .padding(.defaultLayoutPadding)
                    .background {
                        RoundedRectangle(
                            cornerRadius: .s1,
                            style: .continuous
                        )
                        .fill(DColor(.deepBlue60).color)
                    }
                    .padding(.defaultLayoutPadding)
                }
            }
        }
        .onAppear {
            store.send(.toggleGuideBottomSheet)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    {
        var decorationItem: [RewardItemCategory: [Reward]] = [:]
        for key in RewardItemCategory.allCases {
            decorationItem[key] = Reward.previewAllData.filter{ $0.category == key }
            switch key {
            case .decoration, .effect, .sound:
                let itemCount = decorationItem[key]?.count ?? 0
                if (itemCount < 2) {
                    decorationItem[key] = []
                }
            default:
                break
            }
        }
        let context = DecorationStore.Context(
            decorationItem: decorationItem,
            currentDecorationItem: [],
            selectedCategory: .background
        )
        var state = MainStateFactory().makeDecorationState(context: context)
        state.monthlyRecords = Record.previewData
        let store = MainStoreFactory().makeDecorationStore(state: state)
        return DecorationView(store: store)
    }()
}
