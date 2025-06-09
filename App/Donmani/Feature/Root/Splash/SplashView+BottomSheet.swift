//
//  SplashView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 3/20/25.
//

import SwiftUI
import DNetwork
import DesignSystem

extension SplashView {
    func AppStoreView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: { }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText("최신 버전으로 업데이트 부탁드려요!")
                    .style(.h2, .bold, .gray95)
                
                DText("더 나은 서비스 사용 환경을 위해 최신 버전의 앱으로 업데이트를 부탁드립니다.")
                    .style(.b1, .regular, .gray95)
                
                if let url = URL(string: DURL.appStore.urlString) {
                    Link(destination: url) {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            DText("업데이트 하기")
                                .style(.h3, .bold, .deepBlue20)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
