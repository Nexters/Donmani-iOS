//
//  RecordCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import DesignSystem

struct RecordCategory: Hashable {
    
    private let _hashValue: () -> Int
    private let _title: String
    private let _instance: any CategoryProtocol
    private let _color: Color
    private let _image: Image
    private let _miniImage: Image
    private let _uppercaseValue: String

    var title: String {
        _title
    }
    
    var color: Color {
        _color
    }
    
    var image: Image {
        _image
    }
    
    var miniImage: Image {
        _miniImage
    }
    
    var uppercaseTitle: String {
        _uppercaseValue
    }
    
    init<T: CategoryProtocol>(_ instance: T) {
        _title = instance.title
        _hashValue = { instance.hashValue }
        _instance = instance
        _color = instance.color
        _image = instance.sticker
        _miniImage = instance.miniSticker
        _uppercaseValue = instance.uppercaseValue
    }
    
    func getInstance<T: CategoryProtocol>() -> T? {
        _instance as? T
    }

    static func == (lhs: RecordCategory, rhs: RecordCategory) -> Bool {
        lhs._instance.hashValue == rhs._instance.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue())
    }
}
