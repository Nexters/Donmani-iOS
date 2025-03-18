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
            BackgroundView(colors: [
                DColor.backgroundTop,
                DColor.backgroundBottom,
            ])
            DImage(.splashBackgroundStar).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth - 4 * .defaultLayoutPadding)
            DImage(.splashLogo).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth / 3)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("나에게 의미있는\n소비를 발견하는")
                            .font(DFont.font(.t0, weight: .regular))
                            .foregroundStyle(.white)
                        Text("별별소")
                            .font(DFont.font(.t0, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, .defaultLayoutPadding)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 72)
        }
    }
}

#Preview {
    SplashView()
}
