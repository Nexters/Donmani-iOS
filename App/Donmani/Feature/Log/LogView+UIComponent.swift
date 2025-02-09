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
                    .foregroundStyle(DColor(.deepBlue80).color)
            }
            .padding(12)
            
            Text("|")
                .font(DFont.font(.b2, weight: .regular))
                .foregroundStyle(DColor(.deepBlue80).color)
            
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
        destination: @escaping () -> some View
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
    
    func LogEmptyButton(
        isChecked: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                if isChecked {
                    DImage(.check).image
                        .resizable()
                        .frame(width: .s4, height: .s4)
                } else {
                    DImage(.uncheck).image
                        .resizable()
                        .frame(width: .s4, height: .s4)
                }
                
                Text("무소비 했어요")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(
                        isChecked
                        ? DColor(.gray95).color
                        : DColor(.deepBlue80).color
                    )
            }
        }
    }
}
