//
//  Bundle+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import Foundation

private class DesignSystemBundle { }
private let designSystemBundleIdentifier: String = Bundle(for: DesignSystemBundle.self).bundleIdentifier ?? "com.nexters.Donmani.DesignSystem"

public extension Bundle {
    static var designSystem: Bundle {
        return Bundle(identifier: designSystemBundleIdentifier) ?? .main
    }
}
