//
//  DToggle.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import DesignSystem

struct DToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Capsule(style: .continuous)
            .fill(DColor(isOn ? .deepBlue99 : .deepBlue70).color)
            .frame(width: 48, height: 28)
            .overlay {
                HStack(spacing: 0) {
                    if isOn {
                        Spacer()
                    }
                    Circle()
                        .fill(DColor(.deepBlue30).color)
                        .frame(width: 20, height: 20)
                        .padding(4)
                    if !isOn {
                        Spacer()
                    }
                }
            }
    }
}

#Preview {
    DToggle(isOn: .constant(true))
}
