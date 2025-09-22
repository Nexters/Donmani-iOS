//
//  ToastView.swift
//  Donmani
//
//  Created by 문종식 on 9/12/25.
//

import SwiftUI
import DesignSystem

struct ToastView: View {
    @EnvironmentObject private var toastManager: ToastManager
    
    var body: some View {
        ZStack {
            VStack {
                ToastElementView(
                    text: toastManager.title,
                    icon: toastManager.icon
                )
                .opacity(toastManager.position == .top ? 1 : 0)
                
                Spacer()
                ToastElementView(
                    text: toastManager.title,
                    icon: toastManager.icon
                )
                .opacity(toastManager.position == .bottom ? 1 : 0)
            }
            .offset(y: toastManager.offset)
        }
    }
    
    private struct ToastElementView: View {
        let text: String
        let icon: DImageAsset?
        
        var body: some View {
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    DImage(icon ?? .success).image
                        .resizable()
                        .frame(width: .s3, height: .s3)
                    DText(text)
                        .style(.b2, .bold, .white)
                }
                .padding(.s5)
                .background {
                    Capsule(style: .continuous)
                        .fill(DColor.textGuide.opacity(0.9))
                }
                Spacer()
            }
            .padding(40)
        }
    }
}

#Preview {
    ToastView()
}
