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
    @State var isLatestVersion: Bool = true
    let userRepository = UserRespository()
    let recordRepository = RecordRepository()
    let rewardRepository = RewardRepository()
    let fileService = DefaultFileService()
    let completeHandler: (() -> Void)?
    
    init(completeHandler: @escaping () -> Void) {
        self.completeHandler = completeHandler
    }
    
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
                            DText("나에게 의미있는\n소비를 발견하는")
                                .style(.t0, .regular, .white)
                            DText("별별소")
                                .style(.t0, .bold, .white)
                        }
                        .padding(.horizontal, .defaultLayoutPadding)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 72)
                if !isLatestVersion {
                    AppStoreView()
                }
            }
            .onAppear {
                loadData()
            }
        
    }
}

#Preview {
    SplashView() { }
}
