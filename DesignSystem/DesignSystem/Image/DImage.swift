//
//  DImage.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI

public struct DImage {
    @usableFromInline let asset: DImageAsset
    
    public init(_ asset: DImageAsset) {
        self.asset = asset
    }
    
    public var image: Image {
        Image(asset.rawValue, bundle: .designSystem)
    }
    
    public var uiImage: UIImage {
        UIImage(named: asset.rawValue, in: .designSystem, compatibleWith: nil) ?? UIImage()
    }
}
