//
//  SettingView.swift
//  Donmani
//
//  Created by 문종식 on 2/3/25.
//

import SwiftUI
import DesignSystem

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    let width = UIScreen.main.bounds.width
    @State var isPresentingRecordGuideView = false
    @State var isPresentingFeedbackView = false
    @State var isPresentingPrivacyPolicyView = false
    @State var isPresentingEditNameView = false
    @State var isSaveEnabled = true
    @State var userName = DataStorage.getUserName()
    @State var editUserName: String = ""
    
    @FocusState var isFocusToTextField: Bool
    var isSaveEnable: Bool {
        let isValidCount = (2 <= editUserName.count && editUserName.count <= 12)
        let pattern = "^[ㄱ-ㅎ가-힣a-zA-Z0-9\\s]+$"
        let isValidCharacter = (editUserName.range(of: pattern, options: .regularExpression) != nil)
        return isValidCount && isValidCharacter
    }
    
    // TODO: - Add Store
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center, spacing: .defaultLayoutPadding) {
                ZStack {
                    HStack {
                        DBackButton {
                            dismiss()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, .defaultLayoutPadding)
                    Text("설정")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 14)
                
                VStack(alignment: .center, spacing: 12) {
                    DImage(.profile).image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 100, height: 100)
                    HStack(spacing: 6) {
                        Button {
                            editUserName = userName
                            isFocusToTextField = true
                            isPresentingEditNameView = true
                        } label: {
                            Text(userName)
                                .font(.b1, .semibold)
                                .foregroundStyle(.white)
                            
                            DImage(.edit).image
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: .s4, height: .s4)
                        }
                    }
                }
                .padding(.defaultLayoutPadding)
                .padding(.bottom, .defaultLayoutPadding)
                
                VStack(alignment: .leading, spacing: 0) {
                    MenuButton(title: "별별소 기록 규칙") {
                        isPresentingRecordGuideView.toggle()
                    }
                    
                    MenuButton(title: "피드백") {
                        isPresentingFeedbackView.toggle()
                    }
                    
                    MenuButton(title: "개인정보 처리방침") {
                        isPresentingPrivacyPolicyView.toggle()
                    }
                }
                Spacer()
            }
            
            if isPresentingRecordGuideView {
                RecordGuideView()
            }
            
            if isPresentingEditNameView {
                EditNameView()
            }
        }
        .sheet(isPresented: $isPresentingPrivacyPolicyView) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $isPresentingFeedbackView) {
            FeedbackView()
        }
        .navigationBarBackButtonHidden()
    }
    
    private func MenuButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.b1, .bold)
                .foregroundStyle(.white)
                .frame(width: width - .defaultLayoutPadding * 2, alignment: .leading)
                .padding(.horizontal, .defaultLayoutPadding)
                .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingView()
}
