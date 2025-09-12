//
//  NewToastView.swift
//  Donmani
//
//  Created by 문종식 on 9/12/25.
//

import SwiftUI
import DesignSystem

struct NewToastView: View {
    @EnvironmentObject private var toastManager: ToastManager
    
    var body: some View {
        ZStack {
            if toastManager.type != .none {
                VStack {
                    if toastManager.type.position == .bottom {
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            DImage(toastManager.type.icon).image
                                .resizable()
                                .frame(width: .s3, height: .s3)
                            DText(toastManager.type.title)
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
                    
                    if toastManager.type.position == .top {
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    NewToastView()
}
