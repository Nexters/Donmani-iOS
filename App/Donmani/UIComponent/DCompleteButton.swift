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
                    .fill((isActive ? DColor(.gray95) : DColor(.deepBlue20)).color)
                Text("완료")
                    .font(DFont.font(.b1, weight: .bold))
                    .foregroundStyle((isActive ? DColor(.deepBlue20) : DColor(.deepBlue70)).color)
            }
        }
        .allowsHitTesting(isActive)
        .frame(width: 60, height: 40)
        .padding(.bottom, 12)
    }
}

#Preview {
    DCompleteButton(isActive: true) {  }
}
