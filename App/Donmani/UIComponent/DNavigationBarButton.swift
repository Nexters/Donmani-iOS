//
//  DNavigationBarButton.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

struct DNavigationBarButton: View {
    let icon: DImageAsset
    let action: (() -> Void)
    
    init(
        _ icon: DImageAsset,
        _ action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            DImage(icon).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: .s3)
        }
    }
}

#Preview {
    DNavigationBarButton(.calendar) {
        
    }
}
