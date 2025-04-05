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
            DText("소비가 \(store.type.selectTitle)던 이유는?")
                .style(.h2, .bold, .white)
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
    
    func CancelRecordConfirmView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.dismissCancelRecordBottomSheet) }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                VStack(alignment: .leading, spacing: 8) {
                    DText("다음에 기록할까요?")
                        .style(.h2, .bold, .gray99)
                    
                    DText("지금까지 기록한 내용은 저장되지 않아요")
                        .style(.b2, .regular, .deepBlue90)
                }
                
                HStack(spacing: 10) {
                    Button {
                        dismissSheet {
                            store.send(.dismissCancelRecordBottomSheet)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.deepBlue50).color)
                            .frame(height: 58)
                            DText("계속하기")
                                .style(.h3, .bold, .white)
                        }
                    }
                    
                    Button {
                        dismiss()
//                        store.send(.delegate(.popToRecordEntrypointView))
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            DText("다음에 하기")
                                .style(.h3, .bold, .deepBlue20)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
