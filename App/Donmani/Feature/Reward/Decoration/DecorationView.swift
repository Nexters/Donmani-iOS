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
                                DNavigationBarButton("완료") {
                                    store.send(.touchSaveButton)
                                }
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
//                                        .aspectRatio(0.8, contentMode: .fit)
                            }
                        }
                        .padding(.vertical, .defaultLayoutPadding * 2)
                        .overlay {
                            if let decoration = store.selectedDecorationItem[.decoration] {
                                let lottieName = RewardResourceMapper(id: decoration.id, category: .decoration).resource()
                                if !lottieName.isEmpty {
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
                        
                        Spacer()
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
                }
                .frame(width: .screenWidth)
                
                VStack {
                    HStack(spacing: .s4) {
                        ForEach(
                            RewardItemCategory.allCases,
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
                        if store.selectedRewardItemCategory == .sound {
                            HStack{
                                DText("・휴대폰을 흔들면 효과음이 들려요 🎹")
                                    .style(.b2, .medium, .deepBlue90)
                                Spacer()
                            }
                            .padding(.horizontal, .defaultLayoutPadding)
                            .padding(.bottom, .defaultLayoutPadding)
                        }
                    }
                }
                .frame(height: .screenHeight * 0.4)
                .background(DColor(.deepBlue60).color)
            }
            
            if store.selectedRewardItemCategory == .sound {
                EqualizerButton()
            }
            
            if store.isPresentingGuideBottomSheet {
                DecorationGuideBottomSheet()
            }
        }
        .onAppear {
            store.send(.toggleGuideBottomSheet)
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    {
//        let previewData = Reward.previewAllData
//        var decorationItem: [RewardItemCategory: [Reward]] = [:]
//        RewardItemCategory.allCases.forEach { c in
//            decorationItem[c] = previewData
//                .filter { $0.category == c }
//                .sorted { $0.id < $1.id }
//            if (c != .background && c != .byeoltong) {
//                if (decorationItem[c, default: []].count > 0) {
//                    let emptyReward = Reward(id: 100, name: "없음", imageUrl: nil, jsonUrl: nil, soundUrl: nil, category: c, owned: false, newAcquiredFlag: false)
//                    decorationItem[c]?.insert(emptyReward, at: 0)
//                }
//            }
//        }
//        let context = DecorationStore.Context(decorationItem: decorationItem)
//        var state = MainStateFactory().makeDecorationState(context: context)
//        state.monthlyRecords = Record.previewData
//        let store = MainStoreFactory().makeDecorationStore(state: state)
//        return DecorationView(store: store)
//    }()
//}
