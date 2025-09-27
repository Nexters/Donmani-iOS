//
//  DImage.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI

public struct DImage {
    @usableFromInline var asset: DImageAsset = .temp
    @usableFromInline var assetName: String? = nil
    
    public init(_ asset: DImageAsset) {
        self.asset = asset
    }
    
    public init(_ assetName: String) {
        self.assetName = assetName
    }
    
    public var image: Image {
        let name = assetName ?? asset.rawValue
        return Image(name, bundle: .designSystem)
    }
    
    public var uiImage: UIImage {
        let name = assetName ?? asset.rawValue
        return UIImage(named: name, in: .designSystem, compatibleWith: nil) ?? UIImage()
    }
}
