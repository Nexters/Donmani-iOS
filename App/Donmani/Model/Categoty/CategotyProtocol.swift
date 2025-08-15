//
//  CategotyProtocol.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

//import Foundation
//import SwiftUI
//import DesignSystem
//
//protocol CategoryProtocol: Hashable, Equatable {
//    var title: String { get }
//    var assetName: String { get }
//    var color: Color { get }
//    var sticker: Image { get }
//    var miniSticker: Image { get }
//    var uppercaseValue: String { get }
//}
//
//extension CategoryProtocol {
//    public var hashValue: Int {
//        title.hashValue
//    }
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.title == rhs.title
//    }
//    
//    var color: Color {
//        DColor(self.assetName.convertUppercaseFirstChar + "Color").color
//    }
//    
//    var sticker: Image {
//        let name = self.assetName.convertUppercaseFirstChar + "Sticker"
//        return DImage(name).image
//    }
//    
//    var miniSticker: Image {
//        let name = self.assetName.convertUppercaseFirstChar + "MiniSticker"
//        return DImage(name).image
//    }
//}
