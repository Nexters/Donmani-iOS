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
    let horizontalPadding: CGFloat = 20
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
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
                .padding(.horizontal, 20)
                Text("설정")
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.vertical, 14)
            
            VStack(alignment: .center, spacing: 12) {
                Image("TempImage")
                Text("노래하는 농담공")
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(20)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    Button {
                        // TODO: - 개인정보 처리방침
                    } label: {
                        Text("개인정보 처리방침")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: width - horizontalPadding * 2, alignment: .leading)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.vertical, 16)
                    }
                    
                    Button {
                        // TODO: - 피드백
                    } label: {
                        Text("피드백")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: width - horizontalPadding * 2, alignment: .leading)
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, 16)
                    }
                }
                .foregroundStyle(.black)
                
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SettingView()
}
