//
//  RecordBackgroundView.swift
//  Donmani
//
//  Created by 문종식 on 2/15/25.
//

import SwiftUI
import DesignSystem

struct RecordBackgroundView: View {
    let categoryColor: Color
    
    init(_ categoryColor: Color) {
        self.categoryColor = categoryColor
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: .defaultLayoutPadding,
                style: .continuous
            )
            .fill(categoryColor.opacity(0.5))
            RoundedRectangle(
                cornerRadius: .defaultLayoutPadding,
                style: .continuous
            )
            .fill(.white.opacity(0.1))
        }
    }
}

#Preview {
    RecordBackgroundView(.black)
}
