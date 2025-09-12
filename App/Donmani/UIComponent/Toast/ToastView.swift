//
//  ToastView.swift
//  Donmani
//
//  Created by 문종식 on 2/21/25.
//

import SwiftUI
import DesignSystem


struct ToastView: View {
    enum `Type` {
        case warning
        case success
    }
    
    let title: String
    let type: ToastView.`Type`
    
    init(title: String, type: ToastView.`Type` = .warning) {
        self.title = title
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 8) {
            DImage(type == .success ? .success : .warning).image
                .resizable()
                .frame(width: .s3, height: .s3)
            DText(title)
                .style(.b2, .bold, .white)
        }
        .padding(.s5)
        .background {
            Capsule(style: .continuous)
                .fill(DColor.textGuide.opacity(0.9))
        }
    }
}

#Preview {
    ToastView(title: "ToastView", type: .success)
}
