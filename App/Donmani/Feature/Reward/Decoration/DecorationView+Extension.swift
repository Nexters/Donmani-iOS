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
            ForEach(store.decorationItem[itemCategory, default: []], id: \.id) { reward in
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
        if reward.category == .bottle {
            image = mapper.image(isPreview: true).image
        }
        return Group {
            ZStack {
                if reward.category == .background {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(DColor(.deepBlue50).color)
                        .overlay {
                            if reward.category == .decoration && reward.id == 23 {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .padding(-5)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            } else {
                                image
                                    .resizable()
                                    .padding((.s3 / 3) + 0.5)
                            }
                        }
                }
                if (reward.newAcquiredFlag && !reward.name.contains("기본")) {
                    HStack {
                        VStack {
                            Circle()
                                .fill(DColor.noticeColor)
                                .frame(width: .s5, height: .s5)
                                .overlay {
                                    DText("N")
                                        .style(.b4, .bold, .white)
                                        .multilineTextAlignment(.center)
                                }
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(10)
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
}
