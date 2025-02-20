//
//  RecordWritingView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI
import DesignSystem

extension RecordWritingView {
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
}
