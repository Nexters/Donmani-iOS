//
//  DText.swift
//  Donmani
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI
import DesignSystem

/// Donmani 디자인 시스템 Text 컴포넌트
///
/// .
struct DText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: Text {
        Text(text)
    }
}
