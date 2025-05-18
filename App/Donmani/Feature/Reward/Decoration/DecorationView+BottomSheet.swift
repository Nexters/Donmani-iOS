//
//  DecorationView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import SwiftUI
import DesignSystem

extension DecorationView {
    func DecorationGuideBottomSheet() -> some View {
        BottomSheetView(
            addCancelButton: false,
            closeAction: {
                
            }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText(
                    """
                    달이 바뀌어도,
                    내가 꾸민 별통이는 그대로!
                    """
                )
                .style(.h2, .bold, .deepBlue99)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, -4)
                
                DText("달이 바뀌어 새로 열린 별통이는 언제든 꾸밀 수 있어요")
                    .style(.b2, .regular, .deepBlue90)
                    .multilineTextAlignment(.center)
                
                
                DImage(.decorationGuideImage).image
                    .resizable()
                
                DButton(title: "확인했어요.") {
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
