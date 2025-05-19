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
            BackgroundView()
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
                
                
                DImage(.starBottle).image
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 50)
                
                Spacer()
                
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
                    .padding(.vertical, .s5)
                    
                    if store.itemList.isEmpty {
                        Spacer()
                        EmptyItemListView()
                        Spacer()
                    } else {
                        Spacer()
                    }
                }
                .frame(height: .screenHeight * 0.4)
                .background(DColor(.deepBlue60).color)
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
        let context = DecorationStore.Context(decorationItem: [:])
        let state = MainStateFactory().makeDecorationState(context: context)
        let store = MainStoreFactory().makeDecorationStore(state: state)
        return DecorationView(store: store)
    }()
}
