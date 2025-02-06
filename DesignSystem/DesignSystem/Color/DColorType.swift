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
    case pupleBlue10
    case pupleBlue20
    case pupleBlue30
    case pupleBlue40
    case pupleBlue50
    case pupleBlue60
    case pupleBlue70
    case pupleBlue80
    case pupleBlue90
    case pupleBlue95
    case pupleBlue99
    
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
            return "DeepBlue"
        case .pupleBlue10, .pupleBlue20, .pupleBlue30, .pupleBlue40, .pupleBlue50, .pupleBlue60, .pupleBlue70, .pupleBlue80, .pupleBlue90, .pupleBlue95, .pupleBlue99:
            return "PupleBlue"
        case .gray10, .gray20, .gray30, .gray40, .gray50, .gray60, .gray70, .gray80, .gray90, .gray95, .gray99:
            return "GrayScale"
        }
    }
    
    var brightness: Int {
        switch self {
        case .deepBlue10, .pupleBlue10, .gray10: return 10
        case .deepBlue20, .pupleBlue20, .gray20: return 20
        case .deepBlue30, .pupleBlue30, .gray30: return 30
        case .deepBlue40, .pupleBlue40, .gray40: return 40
        case .deepBlue50, .pupleBlue50, .gray50: return 50
        case .deepBlue60, .pupleBlue60, .gray60: return 60
        case .deepBlue70, .pupleBlue70, .gray70: return 70
        case .deepBlue80, .pupleBlue80, .gray80: return 80
        case .deepBlue90, .pupleBlue90, .gray90: return 90
        case .deepBlue95, .pupleBlue95, .gray95: return 95
        case .deepBlue99, .pupleBlue99, .gray99: return 99
        }
    }
}
