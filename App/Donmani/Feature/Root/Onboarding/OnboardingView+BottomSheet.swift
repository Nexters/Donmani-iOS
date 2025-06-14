//
//  OnboardingView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 3/24/25.
//

import SwiftUI
import DesignSystem

extension OnboardingView {
    func OnboardingEndView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: { }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText("규칙은 설정 페이지에서\n언제든지 다시 볼 수 있어!")
                    .style(.h2, .bold, .deepBlue99)
                    .lineSpacing(.s5/2)
                VStack(spacing: 0) {
                    DImage(.onboardingEnd).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    DButton(title: "확인했어요") {
                        store.send(.touchEndOnboarding)
                        completeHandler?(store.startViewtype)
                    }
                }
            }
            .padding(.top, -10)
        }
    }
}
