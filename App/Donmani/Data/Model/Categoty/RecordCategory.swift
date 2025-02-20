//
//  RecordCategory.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import DesignSystem

struct RecordCategory: Equatable {
    
    private let _isEqual: (Any) -> Bool
    private let _hashValue: () -> Int
    private let _title: String
    private let _instance: any CategoryProtocol
    private let _color: Color
    private let _image: Image
    private let _miniImage: Image

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
    
    init<T: CategoryProtocol>(_ instance: T) {
        _title = instance.title
        _isEqual = { ($0 as? T) == instance }
        _hashValue = { instance.hashValue }
        _instance = instance
        _color = instance.color
        _image = instance.sticker
        _miniImage = instance.miniSticker
    }
    
    func getInstance<T: CategoryProtocol>() -> T? {
        _instance as? T
    }

    static func == (lhs: RecordCategory, rhs: RecordCategory) -> Bool {
        lhs._isEqual(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue())
    }
}
