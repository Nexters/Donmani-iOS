//
//  DColor.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI

public struct DColor {
    public static let accessoryButton = Color("accessoryButton", bundle: .designSystem)
    public static let backgroundTop = Color("backgroundTop", bundle: .designSystem)
    public static let backgroundBottom = Color("backgroundBottom", bundle: .designSystem)
    
    public static let textGuide = Color("textGuide", bundle: .designSystem)
    public static let notice = Color("noticeDot", bundle: .designSystem)
    public static let empty = Color("empty", bundle: .designSystem)
    
    public static let mainToolTipBackground = Color("mainToolTipBackground", bundle: .designSystem)
    
    public var type: DColorType = .deepBlue50
    public var name: String? = nil
    
    public var color: Color {
        let name = self.name ?? ("\(type.name)_\(type.brightness)")
        return Color(name, bundle: .designSystem)
    }
    
    public var uiColor: UIColor {
        UIColor(color)
    }
    
    public init(_ type: DColorType) {
        self.type = type
    }
    
    public init(_ name: String) {
        self.name = name
    }
    
}
