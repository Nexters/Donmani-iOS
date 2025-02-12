//
//  RecordWritingView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem

extension RecordWritingView {
    static let categoryColumns = Array(
        repeating: GridItem(.flexible(minimum: 100, maximum: 500)),
        count: 3
    )
    
    func SelectCategoryView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.closeCategory) }
        ) { dismissSheet in
            Text("어떤 \(store.type.title)였나요?")
                .font(DFont.font(.h2, weight: .bold))
                .foregroundStyle(.white)
            LazyVGrid(
                columns: RecordWritingView.categoryColumns,
                spacing: .s3
            ) {
                ForEach(store.category.indices, id: \.self) { i in
                    CategoryButton(
                        category: store.category[i],
                        isSelected: store.category[i].title == (store.selectedCategory?.title ?? "")
                    )
                }
            }
            .padding(.vertical , 24)
            
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
        isSelected: Bool
    ) -> some View {
        Button{
            store.send(.selectCategory(category))
        } label: {
            VStack(spacing: 4) {
//                DImage(.tempImage).image
//                    .resizable()
                DColor(.deepBlue70).color
                    .frame(width: 62, height: 62)
                    .clipShape(RoundedRectangle(cornerRadius: .s5, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: .s5)
                            .stroke(DColor(.deepBlue99).color, lineWidth: isSelected ? 2 : 0)
                    )
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
}
