//
//  SettingView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/18/25.
//

import SwiftUI
import DesignSystem

extension SettingView {
    func RecordGuideView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: {
                
            }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                Text("별별소 기록 규칙")
                    .font(DFont.font(.h2, weight: .bold))
                    .foregroundStyle(DColor(.gray95).color)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("• 매일 행복, 후회 소비를 각각 한 개씩 기록해요")
                    Text("• 기록을 저장한 후에는 수정할 수 없어요")
                    Text("• 어제, 오늘의 소비만 기록할 수 있어요")
                }
                .font(DFont.font(.b1, weight: .regular))
                .foregroundStyle(DColor(.gray95).color)
                
                Text("규칙은 설정에서 다시 확인할 수 있어요")
                    .font(DFont.font(.b2, weight: .regular))
                    .foregroundStyle(DColor(.deepBlue90).color)
                
                Button {
                    dismissSheet {
                        isPresentingRecordGuideView.toggle()
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
    
    func EditNameView() -> some View {
        BottomSheetView(
            closeAction: {
                isPresentingEditNameView = false
            }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s5) {
                VStack(spacing: 4) {
                    TextField(text: $editUserName) { }
                        .font(DFont.font(.b1, weight: .medium))
                        .foregroundStyle(DColor(.gray95).color)
                        .focused($isFocusToTextField)
                        .onChange(of: editUserName) { oldValue, newValue in
                            let isValidCharacter = (editUserName.range(of: pattern, options: .regularExpression) != nil)
                            if (newValue.count == 0) {
                                return
                            }
                            if !isValidCharacter {
                                if !(isPresentingSymbolGuideToastView || isPresentingLengthGuideToastView) {
                                    withAnimation(.linear(duration: 0.5)) {
                                        isPresentingSymbolGuideToastView = true
                                    } completion: {
                                        Task(priority: .low) {
                                            try await Task.sleep(nanoseconds: 3_000_000_000)
                                            withAnimation(.linear(duration: 0.5)) {
                                                isPresentingSymbolGuideToastView = false
                                            }
                                        }
                                    }
                                }
                                
                                editUserName = oldValue
                                return
                            }
                            if newValue.count > 12 {
                                if !(isPresentingSymbolGuideToastView || isPresentingLengthGuideToastView) {
                                    withAnimation(.linear(duration: 0.5)) {
                                        isPresentingLengthGuideToastView = true
                                    } completion: {
                                        Task(priority: .low) {
                                            try await Task.sleep(nanoseconds: 3_000_000_000)
                                            withAnimation(.linear(duration: 0.5)) {
                                                isPresentingLengthGuideToastView = false
                                            }
                                        }
                                    }
                                }
                                editUserName = oldValue
                            }
                        }
                    HStack {
                        Spacer()
                        Text("\(editUserName.count)/12")
                            .font(DFont.font(.b2, weight: .regular))
                            .foregroundStyle(DColor(.deepBlue80).color)
                    }
                }
                .padding(8)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("최소 2자 이상, 최대 12자 이하")
                        Text("한글, 영문, 숫자, 띄어쓰기 가능해요")
                    }
                    .font(DFont.font(.b2, weight: .regular))
                    .foregroundStyle(DColor(.deepBlue80).color)
                    
                    Spacer()
                    DCompleteButton(
                        isActive: isSaveEnable
                    ) {
                        Task {
                            userName = try await NetworkManager.NMUser(service: .shared).updateUser(name: editUserName)
                            DataStorage.setUserName(userName)
                            isPresentingEditNameView = false
                        }
                    }
                    .frame(alignment: .trailing)
                }
            }
        }
        
    }
}
