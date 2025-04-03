//
//  RecordWritingView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem

extension RecordWritingView {
    func ColorBackgroundView(
        color: Color
    ) -> some View {
        ZStack {
            VStack {
                Rectangle()
                    .fill(color)
                    .frame(height: 340)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 120,
                            bottomTrailingRadius: 120,
                            topTrailingRadius: 0,
                            style: .continuous
                        )
                    )
                    .offset(x: 0, y: -200)
                    .blur(radius: 70.0)
                    .padding(.horizontal, -.defaultLayoutPadding * 3)
                Spacer()
            }
        }
    }
    
    func CategoryButton(
        category: RecordCategory,
        isSelected: Bool,
        initState: Bool
    ) -> some View {
        Button{
            store.send(.selectCategory(category))
        } label: {
            VStack(spacing: 4) {
                ((isSelected && !initState) ? category.image : category.miniImage)
                    .resizable()
                    .frame(width: 62, height: 62)
                    .clipShape(RoundedRectangle(cornerRadius: .s5, style: .continuous))
                    .opacity((initState || isSelected) ? 1 : 0.4)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: .s5)
//                            .stroke(DColor(.deepBlue99).color, lineWidth: (isSelected && !initState) ? 2 : 0)
//                    )

                Text(category.title)
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(
                        (isSelected ? DColor(.deepBlue99) : DColor(.deepBlue90)).color
                    )
            }
        }
        .padding(.horizontal, .s5)
    }
    
    func TextGuideView() -> some View {
        HStack(spacing: 8) {
            DImage(.warning).image
                .resizable()
                .frame(width: .s3, height: .s3)
            Text("최대로 작성했어요")
                .font(DFont.font(.b2, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.s5)
        .background {
            Capsule(style: .continuous)
                .fill(DColor.textGuide.opacity(0.9))
        }
    }
    
    
}
