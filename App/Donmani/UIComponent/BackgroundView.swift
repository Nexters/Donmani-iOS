//
//  BackgroundView.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

import SwiftUI
import DesignSystem

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DColor(.deepBlue30).color,
                    DColor(.deepBlue50).color
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .padding(-1)
        }
    }
}

#Preview {
    BackgroundView()
}
