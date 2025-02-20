//
//  MainView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI
import DesignSystem
import DNetwork

extension MainView {
    func AppStoreView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: { }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                Text("최신 버전으로 업데이트 부탁드려요!")
                    .font(DFont.font(.h2, weight: .bold))
                    .foregroundStyle(DColor(.gray95).color)
                
                Text("더 나은 서비스 사용 환경을 위해 최신 버전의 앱으로 업데이트를 부탁드립니다.")
                    .font(DFont.font(.b1, weight: .regular))
                    .foregroundStyle(DColor(.gray95).color)
                
                if let url = URL(string: DNetworkService.appStoreURL) {
                    Link(destination: url) {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            Text("업데이트 하기")
                                .font(DFont.font(.h3, weight: .bold))
                                .foregroundStyle(DColor(.deepBlue20).color)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
