//
//  LogView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

extension LogView {
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
                
                HStack {
                    Button {
                        dismissSheet()
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
                        store.send(.cancelRecording)
                        dismiss()
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
                VStack(alignment: .leading, spacing: 8) {
                    Text("정말 무소비 했나요?")
                        .font(DFont.font(.h2, weight: .bold))
                        .foregroundStyle(DColor(.gray99).color)
                    
                    Text("다시 한 번 오늘의 소비를 돌아보세요.\n지금까지 기록한 내용이 있다면 모두 사라져요!")
                        .font(DFont.font(.b2, weight: .regular))
                        .foregroundStyle(DColor(.deepBlue90).color)
                }
                HStack {
                    Button {
                        dismissSheet()
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.deepBlue50).color)
                            .frame(height: 58)
                            Text("아니야")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Button {
                        store.send(.recordEmpty)
                        dismissSheet()
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            Text("맞아")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(DColor(.deepBlue20).color)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    func RecordSaveConfirmView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.dismissSaveBottomSheet) }
        ) { dismissSheet in
            VStack(spacing: .s3) {
                HStack {
                    Text("저장하면\n이 날에 대한 기록은 더 못해요!")
                        .font(DFont.font(.h2, weight: .bold))
                        .foregroundStyle(DColor(.gray99).color)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                VStack(alignment: .center) {
                    DImage(.save).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 112)
                        .padding(.s3)
                }
                
                DButton(
                    title: "오늘도 해냈다!",
                    isEnabled: true
                ) {
                    store.send(.save)
                    dismissSheet()
                    dismiss()
                }
            }
        }
    }
}
