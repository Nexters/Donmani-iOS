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
            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: .s3) {
                ForEach(0..<3, id: \.self) { row in
                    GridRow {
                        ForEach(0..<3) { column in
                            HStack {
                                Spacer()
                                CategoryButton(
                                    category: store.category[row * 3 + column],
                                    isSelected: store.category[row * 3 + column].title == (store.selectedCategory?.title ?? ""),
                                    initState: (store.selectedCategory == nil)
                                )
                                Spacer()
                            }
                        }
                    }
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
