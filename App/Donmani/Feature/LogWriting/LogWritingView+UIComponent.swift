//
//  LogWritingView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem

extension LogWritingView {
    static let categoryColumns = Array(
        repeating: GridItem(.flexible(minimum: 100, maximum: 500)),
        count: 3
    )
    
    func SelectCategoryView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.closeCategory) }
        ) { _ in
            Text("어떤 \(store.type.title)였나요?")
                .font(DFont.font(.h2, weight: .bold))
                .foregroundStyle(.white)
            LazyVGrid(
                columns: LogWritingView.categoryColumns,
                spacing: .s3
            ) {
                ForEach(store.category.indices, id: \.self) { i in
                    Button{
                        store.send(.selectCategory(store.category[i]))
                    } label: {
                        VStack(spacing: 4) {
                            DImage(.tempImage).image
                                .frame(width: 62, height: 62)
                            Text(store.category[i].title)
                                .font(DFont.font(.b2, weight: .semibold))
                                .foregroundStyle(DColor(.deepBlue90).color)
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .padding(.vertical , 24)
            
            DButton(
                title: "완료",
                isEnabled: store.selectedCategory != nil
            ) {
                
            }
        }
    }
}
