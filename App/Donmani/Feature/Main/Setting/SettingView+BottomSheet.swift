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
                DText("별별소 기록 규칙")
                    .style(.h2, .bold, .gray95)
                DText(
                    """
                    • 매일 행복, 후회 소비를 각각 한 개씩 기록해요
                    • 기록을 저장한 후에는 수정할 수 없어요
                    • 어제, 오늘의 소비만 기록할 수 있어요
                    """
                )
                .style(.b1, .regular, .gray95)
                .lineSpacing(16)
                
                Button {
                    dismissSheet {
                        UINavigationController.isBlockSwipe = false
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
                        DText("이해완료!")
                            .style(.h3, .bold, .deepBlue20)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    func EditNameView() -> some View {
        BottomSheetView(
            closeAction: {
                DispatchQueue.main.async {
                    isFocusToTextField = false
                }
                isPresentingEditNameView = false
                UINavigationController.isBlockSwipe = false
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
                                toastManager.show(.specialCharactersNotAllowed)
                                editUserName = oldValue
                            } else if newValue.count > 12 {
                                toastManager.show(.maxNicknameLengthExceeded)
                                editUserName = oldValue
                            }
                        }
                    HStack {
                        Spacer()
                        DText("\(editUserName.count)/12")
                            .style(.b2, .regular, .deepBlue80)
                    }
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 8)
                
                HStack(alignment: .top) {
                    DText("최소 2자 이상, 최대 12자 이하\n한글, 영문, 숫자, 띄어쓰기 가능해요")
                        .style(.b2, .regular, .deepBlue80)
                        .lineSpacing(8)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    DCompleteButton(
                        isActive: isSaveEnable
                    ) {
                        isFocusToTextField = false
                        Task {
                            let newUserName = try await userUseCase.update(newUserName: editUserName).userName
                            isPresentingEditNameView = false
                            store.send(.updateUserName(newUserName))
                            UINavigationController.isBlockSwipe = false
                        }
                    }
                    .frame(alignment: .trailing)
                }
            }
        }
        
    }
}
