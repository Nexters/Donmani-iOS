//
//  DBackButton.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

struct DBackButton: View {
    let action: (() -> Void)
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            DImage(.leftArrow).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: .s3)
        }
    }
}

#Preview {
    DBackButton { }
}
