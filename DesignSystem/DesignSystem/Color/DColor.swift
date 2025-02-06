//
//  DColor.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI

public struct DColor {
    public static let accessoryButton: Color = Color("AccessoryButton", bundle: .designSystem)
    public static let backgroundTop: Color = Color("BackgroundTop", bundle: .designSystem)
    public static let backgroundBottom: Color = Color("BackgroundBottom", bundle: .designSystem)
    
    public var type: DColorType
    public var color: Color {
        Color("\(type.name)\(type.brightness)", bundle: .designSystem)
    }
    public var uiColor: UIColor {
        UIColor(color)
    }
    
    public init(_ type: DColorType) {
        self.type = type
    }
    
}
