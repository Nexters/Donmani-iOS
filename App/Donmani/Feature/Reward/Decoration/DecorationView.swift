//
//  DecorationView.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

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
                                    store.send(.delegate(.popToRoot))
                                }
                                Spacer()
                                DNavigationBarButton("완료") {
                                    store.send(.delegate(.popToRoot))
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
                                .aspectRatio(0.75, contentMode: .fit)
                            
                            if let byeoltong = store.selectedDecorationItem[.byeoltong] {
                                StarBottle(
                                    backgroundShapeImage: RewardResourceMapper(
                                        id: byeoltong.id,
                                        category: .byeoltong
                                    )
                                    .image()
                                )

                            }
                            
                        }
                        Spacer()
                    }
                }
                
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

#Preview {
    {
        let previewData = Reward.previewAllData
        var decorationItem: [RewardItemCategory: [Reward]] = [:]
        RewardItemCategory.allCases.forEach { c in
            decorationItem[c] = previewData
                .filter { $0.category == c }
                .sorted { $0.id < $1.id }
            if (c != .background && c != .byeoltong) {
                if (decorationItem[c, default: []].count > 0) {
                    let emptyReward = Reward(id: 100, name: "없음", imageUrl: nil, soundUrl: nil, category: c, owned: false)
                    decorationItem[c]?.insert(emptyReward, at: 0)
                }
            }
        }
        let context = DecorationStore.Context(decorationItem: decorationItem)
        let state = MainStateFactory().makeDecorationState(context: context)
        let store = MainStoreFactory().makeDecorationStore(state: state)
        return DecorationView(store: store)
    }()
}
