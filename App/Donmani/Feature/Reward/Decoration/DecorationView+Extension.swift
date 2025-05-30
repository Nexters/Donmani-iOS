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

extension DecorationView{
    func EmptyItemListView() -> some View {
        VStack(spacing: 12) {
            DText("아직 아이템이 없어요!")
                .style(.h2, .bold, .deepBlue99)
            DText("기록하면 아이템을 받을 수 있어요")
                .style(.b2, .regular, .deepBlue90)
        }
    }
    
    func ItemGridView(itemCategory: RewardItemCategory) -> some View {
        let columns = [
            GridItem(.flexible(), spacing: 5),
            GridItem(.flexible(), spacing: 5),
            GridItem(.flexible(), spacing: 5)
        ]
        let size: CGFloat = (.screenWidth / 3 - .defaultLayoutPadding)
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(store.decorationItem[itemCategory, default: []], id: \.key) { reward in
                Button {
                    store.send(.touchRewardItem(itemCategory, reward))
                } label: {
                    ZStack {
                        ItemGridImage(reward: reward)
                            .frame(width: size, height: size)
                        if let selectedItem = store.selectedDecorationItem[itemCategory] {
                            if selectedItem.id == reward.id {
                                RoundedRectangle(
                                    cornerRadius: .s5,
                                    style: .continuous
                                )
                                .strokeBorder(.white, lineWidth: 2)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, .defaultLayoutPadding / 2.0)
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    func ItemGridImage(reward: Reward) -> some View {
        let mapper = RewardResourceMapper(id: reward.id, category: reward.category)
        var image = mapper.image().image
        if reward.category == .byeoltong {
            image = mapper.image(isPreview: true).image
        }
        return Group {
            if reward.category == .background {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(DColor(.deepBlue50).color)
                    .overlay {
                        image.padding(.s3 / 3)
                    }
            }
        }
    }
    
    func StarBottle(
        backgroundShapeImage: DImage
    ) -> some View {
        backgroundShapeImage
            .image
            .resizable()
            .scaledToFit()
            .padding(.vertical, 50)
    }
    
    func EqualizerButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    store.send(.touchEqualizerButton)
                } label: {
                    Group {
                        if store.isSoundOn {
                            LottieView(animation: store.lottieAnimation)
                                .playing(loopMode: .loop)
                        } else {
                            LottieView(animation: store.lottieAnimation)
                                .paused()
                                .opacity(0.2)
                        }
                    }
                    .frame(width: .s3, height: .s3)
                }
                .frame(width: .s3, height: .s3)
                .padding(.s4)
                Spacer()
            }
        }
        .padding(.bottom, .screenHeight * 0.4)
    }
    
}
