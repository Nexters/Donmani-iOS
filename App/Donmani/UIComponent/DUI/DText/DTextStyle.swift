//
//  DTextStyle.swift
//  Donmani
//
//  Created by 문종식 on 4/9/25.
//

import SwiftUI
import DesignSystem

struct DTextStyle: ViewModifier {
    let style: DFontStyle
    let weight: DFontWeight
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(DFont.font(style, weight: weight))
            .foregroundStyle(color)
    }
}
