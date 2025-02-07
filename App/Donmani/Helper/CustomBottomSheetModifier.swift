//
//  CustomBottomSheetModifier.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI

public extension View {
    func customBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(CustomBottomSheetModifier(isPresented: isPresented, sheetContent: content))
    }
}

struct CustomBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                    .transition(.opacity)

                VStack {
                    sheetContent()
                }
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .bottom)) 
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}
