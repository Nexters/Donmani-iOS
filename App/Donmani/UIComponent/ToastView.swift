//
//  ToastView.swift
//  Donmani
//
//  Created by 문종식 on 2/21/25.
//

import SwiftUI
import DesignSystem

struct ToastView: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            DImage(.warning).image
                .resizable()
                .frame(width: .s3, height: .s3)
            Text(title)
                .font(DFont.font(.b2, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.s5)
        .background {
            Capsule(style: .continuous)
                .fill(DColor.textGuide.opacity(0.9))
        }
    }
}

#Preview {
    ToastView(title: "ToastView")
}
