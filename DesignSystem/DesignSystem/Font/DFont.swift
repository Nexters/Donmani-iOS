//
//  DFont.swift
//  DesignSystem
//
//  Created by 문종식 on 2/3/25.
//

import SwiftUI

public struct DFont {
    private static let fontName: String = "Pretendard"
    
    public static func font(_ style: DFontStyle, weight: DFontWeight = .regular) -> Font {
        return Font(uiFont(style, weight: weight))
    }
    
    public static func uiFont(_ style: DFontStyle, weight: DFontWeight = .regular) -> UIFont {
        return UIFont(name: "\(fontName)-\(weight.rawValue)", size: style.size) ?? UIFont.systemFont(ofSize: style.size, weight: .regular)
    }
}
