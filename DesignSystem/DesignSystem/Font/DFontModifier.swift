//
//  DFontModifier.swift
//  DesignSystem
//
//  Created by 문종식 on 2/3/25.
//

import SwiftUI

public struct DFontModifier: ViewModifier {
    public let style: DFontStyle
    public let weight: DFontWeight
    
    public init(style: DFontStyle, weight: DFontWeight) {
        self.style = style
        self.weight = weight
    }
    
    public func body(content: Content) -> some View {
        content.font(DFont.font(style, weight: weight))
    }
}
