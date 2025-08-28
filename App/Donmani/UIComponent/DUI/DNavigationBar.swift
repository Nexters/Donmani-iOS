//
//  DNavigationBar.swift
//  Donmani
//
//  Created by 문종식 on 8/28/25.
//

import SwiftUI
import DesignSystem

struct DNavigationBar<Leading: View, Title: View, Trailing: View>: View {
    private let leading: () -> Leading
    private let title: () -> Title
    private let trailing: () -> Trailing
    
    init(
        @ViewBuilder leading: @escaping () -> Leading,
        @ViewBuilder title: @escaping () -> Title,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.leading = leading
        self.title = title
        self.trailing = trailing
    }
    
    var body: some View {
        VStack(spacing: .s1) {
            HStack {
                leading()
                Spacer()
                trailing()
            }
            .padding(.vertical, .s5)
            HStack {
                Spacer()
                title()
                Spacer()
            }
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
}

#Preview {
    DNavigationBar(
        leading: {
            
        }, title: {
            
        }, trailing: {
            
        }
    )
}
