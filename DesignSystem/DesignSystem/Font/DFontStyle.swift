//
//  DFontStyle.swift
//  DesignSystem
//
//  Created by 문종식 on 2/3/25.
//

public enum DFontStyle {
    case t1
    case h1, h2, h3
    case b1, b2, b3, b4
    
    var size: CGFloat {
        switch self {
        case .t1: return 30
            
        case .h1: return 24
        case .h2: return 20
        case .h3: return 18
            
        case .b1: return 16
        case .b2: return 14
        case .b3: return 12
        case .b4: return 10
        }
    }
}
