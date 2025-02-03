//
//  SettingView.swift
//  Donmani
//
//  Created by 문종식 on 2/3/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    let width = UIScreen.main.bounds.width
    
    let defaultPadding: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .center, spacing: defaultPadding) {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 24, height: 24)
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 14)
                                .foregroundStyle(.black)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, defaultPadding)
                Text("설정")
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.vertical, 14)
            
            VStack(alignment: .center, spacing: 12) {
                Image("TempImage")
                Text("노래하는 농담곰")
                    .font(.b1, .semibold)
            }
            .padding(defaultPadding)
            .padding(.bottom, defaultPadding)
            
            VStack(alignment: .leading, spacing: 0) {
                MenuButton(title: "개인정보 처리방침") {
                    
                }
                
                MenuButton(title: "피드백") {
                    
                }
            }
            Spacer()
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
                .foregroundStyle(.black)
                .frame(width: width - defaultPadding * 2, alignment: .leading)
                .padding(.horizontal, defaultPadding)
                .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingView()
}
