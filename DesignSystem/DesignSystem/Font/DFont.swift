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
    
    // Font Resource Load
    public static func loadFonts() {
        for fontWeight in DFontWeight.allCases {
            registerFont(name: "\(fontName)-\(fontWeight.rawValue)")
        }
    }
    
    private static func registerFont(name: String) {
        guard let fontURL = Bundle.designSystem.url(forResource: name, withExtension: "ttf") else {
            return
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            return
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
