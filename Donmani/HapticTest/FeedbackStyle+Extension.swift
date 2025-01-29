//
//  Untitled.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import UIKit

typealias Feedback = UIImpactFeedbackGenerator.FeedbackStyle

extension Feedback: @retroactive CaseIterable {
    public static var allCases: [UIImpactFeedbackGenerator.FeedbackStyle] {
        [.heavy, .medium, .light, .rigid, .soft]
    }
    public var title: String {
        switch self {
        case .heavy:
            return "Heavy"
        case .medium:
            return "Medium"
        case .light:
            return "Light"
        case .rigid:
            return "Rigid"
        case .soft:
            return "Soft"
        @unknown default:
            return ""
        }
    }
}
