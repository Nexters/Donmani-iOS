//
//  SplashView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct SplashView: View {
    @Dependency(\.settings) var settings
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.appVersionRepository) var appVersionRepository
    @Dependency(\.fileRepository) var fileRepository
    
    @State var isLatestVersion: Bool = true
    let completeHandler: (() -> Void)?
    
    init(completeHandler: @escaping () -> Void) {
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        ZStack {
            DImage(.splashBackgroundStar).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth - 4 * .defaultLayoutPadding)
            DImage(.splashLogo).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth / 3)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    DText("나에게 의미있는\n소비를 발견하는")
                        .style(.t0, .regular, .white)
                    DText("별별소")
                        .style(.t0, .bold, .white)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal, .defaultLayoutPadding)
            .padding(.top, .s3 * 3)
            
            if !isLatestVersion {
                AppStoreView()
            }
        }
        .onAppear {
            loadData()
        }
        .background {
            BackgroundView(colors: [
                DColor.backgroundTop,
                DColor.backgroundBottom,
            ])
        }
    }
}

#Preview {
    SplashView() { }
}
