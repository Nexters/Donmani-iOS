//
//  DColorType.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/25.
//

public enum DColorType {
    // Primary
    case deepBlue10
    case deepBlue20
    case deepBlue30
    case deepBlue40
    case deepBlue50
    case deepBlue60
    case deepBlue70
    case deepBlue80
    case deepBlue90
    case deepBlue95
    case deepBlue99
    
    // Secondary
    case purpleBlue10
    case purpleBlue20
    case purpleBlue30
    case purpleBlue40
    case purpleBlue50
    case purpleBlue60
    case purpleBlue70
    case purpleBlue80
    case purpleBlue90
    case purpleBlue95
    case purpleBlue99
    
    // Gray
    case gray10
    case gray20
    case gray30
    case gray40
    case gray50
    case gray60
    case gray70
    case gray80
    case gray90
    case gray95
    case gray99
    
    var name: String {
        switch self {
        case .deepBlue10, .deepBlue20, .deepBlue30, .deepBlue40, .deepBlue50, .deepBlue60, .deepBlue70, .deepBlue80, .deepBlue90, .deepBlue95, .deepBlue99:
            return "deep_blue"
        case .purpleBlue10, .purpleBlue20, .purpleBlue30, .purpleBlue40, .purpleBlue50, .purpleBlue60, .purpleBlue70, .purpleBlue80, .purpleBlue90, .purpleBlue95, .purpleBlue99:
            return "purple_blue"
        case .gray10, .gray20, .gray30, .gray40, .gray50, .gray60, .gray70, .gray80, .gray90, .gray95, .gray99:
            return "gray"
        }
    }
    
    var brightness: Int {
        switch self {
        case .deepBlue10, .purpleBlue10, .gray10: return 10
        case .deepBlue20, .purpleBlue20, .gray20: return 20
        case .deepBlue30, .purpleBlue30, .gray30: return 30
        case .deepBlue40, .purpleBlue40, .gray40: return 40
        case .deepBlue50, .purpleBlue50, .gray50: return 50
        case .deepBlue60, .purpleBlue60, .gray60: return 60
        case .deepBlue70, .purpleBlue70, .gray70: return 70
        case .deepBlue80, .purpleBlue80, .gray80: return 80
        case .deepBlue90, .purpleBlue90, .gray90: return 90
        case .deepBlue95, .purpleBlue95, .gray95: return 95
        case .deepBlue99, .purpleBlue99, .gray99: return 99
        }
    }
}
