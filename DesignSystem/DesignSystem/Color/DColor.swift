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
    
    public static let textGuide: Color = Color("TextGuide", bundle: .designSystem)
    public static let noticeColor: Color = Color("NoticeColor", bundle: .designSystem) 
    public static let emptyColor: Color = Color("EmptyColor", bundle: .designSystem)
    
    public static let mainToolTipBackgroundColor: Color = Color("MainToolTipBackgroundColor", bundle: .designSystem)
    
    public var type: DColorType = .deepBlue50
    public var name: String? = nil
    
    public var color: Color {
        let name = self.name ?? ("\(type.name)\(type.brightness)")
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
