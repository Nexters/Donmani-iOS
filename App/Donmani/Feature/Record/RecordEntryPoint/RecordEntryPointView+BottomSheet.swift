//
//  RecordEntryPointView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

extension RecordEntryPointView {
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
                        dismissSheet {
                            store.send(.cancelRecording)
//                            dismiss()
                        }
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
    
    func RecordEmptyConfirmView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.dismissEmptyRecordBottomSheet) }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                VStack(alignment: .leading, spacing: 12) {
                    DText("정말 무소비 했나요?")
                        .style(.h2, .bold, .gray99)
                    DText("무소비는 하루 동안 한 번도 소비하지 않았을 때 선택해요.\n지금까지 기록한 내용이 있다면 모두 사라져요!")
                        .style(.b2, .regular, .deepBlue90)
                        .lineSpacing(6)
                    
                }
                HStack(spacing: 10) {
                    Button {
                        dismissSheet {
                            store.send(.dismissEmptyRecordBottomSheet)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.deepBlue50).color)
                            .frame(height: 58)
                            DText("안했어요")
                                .style(.h3, .bold, .white)
                        }
                    }
                    
                    Button {
                        dismissSheet {
                            store.send(.recordEmpty)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            DText("했어요")
                                .style(.h3, .bold, .deepBlue20)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
}
