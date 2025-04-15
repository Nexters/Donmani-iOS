//
//  DButton.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

struct DButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = false
    
    init(
        title: String,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.isEnabled = isEnabled
    }
    
    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.isEnabled = true
    }
    
    var body: some View {
        Button {
            if isEnabled {
                action()
            }
        } label: {
            ZStack {
                RoundedRectangle(
                    cornerRadius: .s5,
                    style: .continuous
                )
                .fill(
                    isEnabled
                    ? DColor(.gray95).color
                    : DColor(.deepBlue20).color
                )
                DText(title)
                    .style(.h3, .bold, isEnabled ? .deepBlue20 : .deepBlue70)
            }
        }
        .frame(height: 58)
        .allowsHitTesting(isEnabled)
    }
}


