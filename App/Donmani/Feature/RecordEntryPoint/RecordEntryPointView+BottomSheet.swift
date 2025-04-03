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
                    Text("다음에 기록할까요?")
                        .font(DFont.font(.h2, weight: .bold))
                        .foregroundStyle(DColor(.gray99).color)
                    
                    Text("지금까지 기록한 내용은 저장되지 않아요")
                        .font(DFont.font(.b2, weight: .regular))
                        .foregroundStyle(DColor(.deepBlue90).color)
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
                            Text("계속하기")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Button {
                        dismissSheet {
                            store.send(.cancelRecording)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            Text("다음에 하기")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(DColor(.deepBlue20).color)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    func RecordEmptyConfirmView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.dismissEmtpyRecordBottomSheet) }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("정말 무소비 했나요?")
                        .font(DFont.font(.h2, weight: .bold))
                        .foregroundStyle(DColor(.gray99).color)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("무소비는 하루 동안 한 번도 소비하지 않았을 때 선택해요.")
                        Text("지금까지 기록한 내용이 있다면 모두 사라져요!")
                    }
                    .font(DFont.font(.b2, weight: .regular))
                    .foregroundStyle(DColor(.deepBlue90).color)
                    
                }
                HStack(spacing: 10) {
                    Button {
                        dismissSheet {
                            store.send(.dismissEmtpyRecordBottomSheet)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.deepBlue50).color)
                            .frame(height: 58)
                            Text("안했어요")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(.white)
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
                            Text("했어요")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(DColor(.deepBlue20).color)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
    
    
    func RecordGuideView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: {
                UINavigationController.blockSwipe = false
            }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                Text("별별소 기록 규칙")
                    .font(DFont.font(.h2, weight: .bold))
                    .foregroundStyle(DColor(.gray95).color)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("• 매일 행복, 후회 소비를 각각 한 개씩 기록해요")
                    Text("• 기록을 저장한 후에는 수정할 수 없어요")
                    Text("• 어제, 오늘의 소비만 기록할 수 있어요")
                }
                .font(DFont.font(.b1, weight: .regular))
                .foregroundStyle(DColor(.gray95).color)
                
                Button {
                    dismissSheet {
                        UINavigationController.blockSwipe = false
                        store.send(.dismissRecordGuideBottomSheet)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(
                            cornerRadius: 16.0,
                            style: .continuous
                        )
                        .fill(DColor(.gray95).color)
                        .frame(height: 58)
                        Text("이해완료!")
                            .font(DFont.font(.h3, weight: .bold))
                            .foregroundStyle(DColor(.deepBlue20).color)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
