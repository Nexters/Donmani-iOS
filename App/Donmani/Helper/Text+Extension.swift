//
//  Text+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI
import DesignSystem

public extension Text {
    func font(_ style: DFontStyle, _ weight: DFontWeight = .regular) -> some View {
        self.modifier(DFontModifier(style: style, weight: weight))
    }
}
