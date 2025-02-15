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
                    DImage(.tempImage).image
                    Text("노래하는 농담곰")
                        .font(.b1, .semibold)
                        .foregroundStyle(.white)
                }
                .padding(.defaultLayoutPadding)
                .padding(.bottom, .defaultLayoutPadding)
                
                VStack(alignment: .leading, spacing: 0) {
                    MenuButton(title: "개인정보 처리방침") {
                        
                    }
                    
                    MenuButton(title: "피드백") {
                        
                    }
                }
                Spacer()
                
            }
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
