//
//  MonthlyStarBottleView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import SwiftUI
import DesignSystem

extension MonthlyStarBottleView {
    func TopBannerView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .s5, style: .circular)
                .fill(DColor(.deepBlue60).color)
                .frame(height: 56)
            HStack(alignment: .center, spacing: 8) {
                DImage(.notice).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
                Text("매 월 1일에 새로운 별통이가 열려요")
                    .font(DFont.font(.b1, weight: .regular))
                    .foregroundStyle(DColor(.gray95).color)
                Spacer()
            }
            .padding(.s5)
        }
        .padding(.top, .s5)
    }
}
