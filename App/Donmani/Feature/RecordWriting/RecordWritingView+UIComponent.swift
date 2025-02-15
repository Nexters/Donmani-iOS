//
//  RecordWritingView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem
import Glur

extension RecordWritingView {
    static let categoryColumns = Array(
        repeating: GridItem(.flexible(minimum: 100, maximum: 500)),
        count: 3
    )
    
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
                            bottomLeadingRadius: 27,
                            bottomTrailingRadius: 27,
                            topTrailingRadius: 0,
                            style: .continuous
                        )
                    )
                    .offset(x: 0, y: -170)
                    .blur(radius: 70.0)
                    .padding(.horizontal, -.screenWidth)
                Spacer()
            }
        }
    }
                        
    
    func SelectCategoryView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.closeCategory) }
        ) { dismissSheet in
            Text("소비가 \(store.type.selectTitle)던 이유는?")
                .font(DFont.font(.h2, weight: .bold))
                .foregroundStyle(.white)
            LazyVGrid(
                columns: RecordWritingView.categoryColumns,
                spacing: .s3
            ) {
                ForEach(store.category.indices, id: \.self) { i in
                    CategoryButton(
                        category: store.category[i],
                        isSelected: store.category[i].title == (store.selectedCategory?.title ?? ""),
                        initState: (store.selectedCategory == nil)
                    )
                }
            }
            .padding(.vertical, .s3)
            
            DButton(
                title: "완료",
                isEnabled: store.selectedCategory != nil
            ) {
                if let selectedCategory = store.selectedCategory {
                    dismissSheet {
                        store.send(.saveCategory(selectedCategory))
                    }
                }
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
    
    func SaveButton(
        iaActive: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                Capsule(style: .circular)
                    .fill((iaActive ? DColor(.gray95) : DColor(.deepBlue20)).color)
                Text("완료")
                    .font(DFont.font(.b1, weight: .bold))
                    .foregroundStyle((iaActive ? DColor(.deepBlue20) : DColor(.deepBlue70)).color)
            }
        }
        .frame(width: 60, height: 40)
        .padding(.bottom, 8)
    }
    
    func TextGuideView() -> some View {
        HStack(spacing: 8) {
            DImage(.textMaxLength).image
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
