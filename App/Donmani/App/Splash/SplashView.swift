//
//  SplashView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem

struct SplashView: View {
    var body: some View {
        ZStack {
            MainBackgroundView(starCount: 10)
            DImage(.splashLogo).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth / 3)
            VStack(alignment: .leading) {
                Text("나에게 의미있는\n소비를 발견하는")
                    .font(DFont.font(.t0, weight: .regular))
                    .foregroundStyle(.white)
                Text("별별소")
                    .font(DFont.font(.t0, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.top, 72)
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
}

#Preview {
    SplashView()
}
