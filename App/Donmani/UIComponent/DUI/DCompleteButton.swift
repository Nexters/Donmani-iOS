//
//  DCompleteButton.swift
//  Donmani
//
//  Created by 문종식 on 2/18/25.
//

import SwiftUI
import DesignSystem

struct DCompleteButton: View {
    let isActive: Bool
    let action: (() -> Void)
    
    init(
        isActive: Bool,
        action: @escaping () -> Void
    ) {
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Capsule(style: .circular)
                    .fill(DColor(isActive ? .gray95 : .deepBlue20).color)
                DText("완료")
                    .style(.b1, .bold, isActive ? .deepBlue20 : .deepBlue70)
            }
        }
        .allowsHitTesting(isActive)
        .frame(width: 60, height: 40)
        .padding(.bottom, 12)
    }
}
