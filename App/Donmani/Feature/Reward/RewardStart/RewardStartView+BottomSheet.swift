//
//  RewardStartView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import SwiftUI
import DesignSystem
import Lottie

extension RewardStartView {
    func RewardGuideBottomSheet() -> some View {
        BottomSheetView(
            addCancelButton: false,
            closeAction: {
                store.send(.toggleGuideBottomSheet)
            }
        ) { dismissSheet in
            VStack(alignment: .center, spacing: .s3) {
                DText(
                    """
                    오늘부터 12번 기록하면
                    특별한 선물을 받아요
                    """
                )
                .style(.h2, .bold, .deepBlue99)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, -4)
                
                DText("기록할 때마다 하나씩, 모두 모으면 숨겨진 선물이?!")
                    .style(.b2, .regular, .deepBlue90)
                    .multilineTextAlignment(.center)
                
                
                LottieView(animation: store.lottieAnimation)
                    .playing(loopMode: .loop)
                    .frame(height: .screenWidth * (12/25))
                    
                
                DButton(title: "첫 선물 받기") {
                    dismissSheet {
                        store.send(.touchGuideBottomSheetButton)
                    }
                }
                .padding(.top, .defaultLayoutPadding / 2)
                .padding(.bottom, -.defaultLayoutPadding)
            }
        }
    }
}
