//
//  DText.swift
//  Donmani
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI
import DesignSystem

/// Donmani 디자인 시스템 Text 컴포넌트
///
/// .
struct DText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: Text {
        Text(text)
    }
}

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


