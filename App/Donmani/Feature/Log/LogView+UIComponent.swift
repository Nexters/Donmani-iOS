//
//  LogView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import DesignSystem

extension LogView {
    func DayToggle() -> some View {
        HStack(spacing: 0) {
            Button {
                
            } label: {
                Text("어제")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(DColor.deepBlue80)
            }
            .padding(12)
            
            Text("|")
                .font(DFont.font(.b2, weight: .regular))
                .foregroundStyle(DColor.deepBlue80)
            
            Button {
                
            } label: {
                Text("오늘")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(DColor.accessoryButton)
            }
            .padding(12)
        }
    }
    
    func LogButton(
        title: String,
        destination: () -> some View
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            ZStack {
                RoundedRectangle(
                    cornerRadius: .defaultLayoutPadding,
                    style: .continuous
                )
                .fill(.white.opacity(0.1))
                HStack {
                    Text(title)
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    DImage(.addLog).image
                        .resizable()
                        .frame(width: .s1, height: .s1)
                }
                .padding(.defaultLayoutPadding)
            }
        }
        .frame(height: 118)
    }
    
    func LogEmptyButton() -> some View {
        Button {
            
        } label: {
            HStack(spacing: 4) {
                DImage(.uncheck).image
                    .resizable()
                    .frame(width: .s4, height: .s4)
                Text("무소비 했어요")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(DColor.deepBlue80)
            }
        }
    }
}
