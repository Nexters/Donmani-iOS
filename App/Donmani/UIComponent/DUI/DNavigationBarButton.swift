//
//  DNavigationBarButton.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

struct DNavigationBarButton: View {
    var icon: DImageAsset? = nil
    var text: String? = nil
    let action: (() -> Void)
    
    init(
        _ icon: DImageAsset,
        _ action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
    }
    
    init(
        _ text: String,
        _ action: @escaping () -> Void
    ) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            if let icon {
                DImage(icon).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3)
            }
            if let text {
                DText(text)
                    .style(.b1, .semibold, .deepBlue99)
                    .frame(width: .s3)
            }
        }
        .frame(width: .s3, height: .s3)
    }
}
