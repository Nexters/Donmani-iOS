//
//  DText+Extension.swift
//  Donmani
//
//  Created by 문종식 on 4/9/25.
//

import SwiftUI
import DesignSystem

extension DText {
    /// DText 전용 Style Modifier - Color
    ///
    /// .
    func style(
        _ style: DFontStyle,
        _ weight: DFontWeight,
        _ color: Color
    ) -> some View {
        self.modifier(DTextStyle(
            style: style,
            weight: weight,
            color: color
        ))
    }
    
    /// DText 전용 Style Modifier - DColorType
    ///
    /// .
    func style(
        _ style: DFontStyle,
        _ weight: DFontWeight,
        _ color: DColorType
    ) -> some View {
        self.modifier(DTextStyle(
            style: style,
            weight: weight,
            color: DColor(color).color
        ))
    }
}


