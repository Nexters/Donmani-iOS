//
//  LogView.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct LogView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<LogReducer>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(
                alignment: .center,
                spacing: .defaultLayoutPadding
            ) {
                // Navigation Bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        DImage(.leftArrow).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s3, height: .s3)
                    }
                    Spacer()
                    DayToggle()
                }
                .frame(height: .navigationBarHeight)
                
                Text(store.title)
                    .font(DFont.font(.h1, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                // 기록 버튼
                VStack(
                    alignment: .leading,
                    spacing: .s4
                ) {
                    LogButton(title: "행복") {
                        Text("")
                    }
                    LogButton(title: "후회") {
                        Text("")
                    }
                    LogEmptyButton()
                }
                
                Spacer()
                
                // 저장
                VStack(spacing: 0) {
                    Text("너의 소비를 별사탕으로 바꿔줄게!")
                        .font(DFont.font(.b2, weight: .semibold))
                        .foregroundStyle(DColor.pupleBlue90)
                        .padding(8)
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: .s5,
                                style: .continuous
                            )
                            .fill(DColor.deepBlue20)
                            Text("저장하기")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(DColor.deepBlue70)
                        }
                    }
                    .frame(height: 58)
                    .padding(8)
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LogView(
        store: Store(
            initialState: LogReducer.LogState(
                isCompleteToday: false,
                isCompleteYesterday: false
            ),
            reducer: {
                
            }
        )
    )
}
