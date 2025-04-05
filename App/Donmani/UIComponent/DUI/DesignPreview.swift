//
//  DesignPreview.swift
//  Donmani
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI
import DesignSystem

#Preview {
    ZStack {
        Color(.black).opacity(0.05)
        VStack(spacing: 4) {
            Spacer()
            DToggle(isOn: .constant(true))
            DToggle(isOn: .constant(false))
            DNavigationBarButton(.calendar) { }
            DCompleteButton(isActive: true) { }
            DCompleteButton(isActive: false) { }
            DButton(title: "Button", isEnabled: true) { }
            DButton(title: "Button", isEnabled: false) { }
            DText("Text").style(.h1, .bold, .black)
            DText("Text").style(.b2, .semibold, .deepBlue40)
            Spacer()
        }
        .padding(.defaultLayoutPadding)
    }
}
