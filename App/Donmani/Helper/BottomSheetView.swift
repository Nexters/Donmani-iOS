//
//  BottomSheetView.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem

struct BottomSheetView<Content: View>: View {
    let closeAction: () -> Void
    let content: (@escaping () -> Void) -> Content
    @State private var isPresented = false
    
    init(
        closeAction: @escaping () -> Void,
        @ViewBuilder _ content: @escaping (@escaping () -> Void) -> Content
    ) {
        self.closeAction = closeAction
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(isPresented ? 0.6 : 0)
                .onTapGesture {
                    dismiss()
                }
                .animation(.easeInOut(duration: 0.3), value: isPresented)
                .ignoresSafeArea()
            if isPresented {
                VStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                DImage(.close).image
                                    .resizable()
                                    .frame(width: .s2, height: .s2)
                            }
                        }
                        .padding(.bottom, .s3)
                        
                        content(dismiss)
                    }
                    .padding(.defaultLayoutPadding)
                    .background {
                        DColor(.deepBlue60).color
                            .clipShape(
                                .rect(
                                    topLeadingRadius: .s1,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: .s1,
                                    style: .continuous
                                )
                            )
                            .ignoresSafeArea(.all, edges: .bottom)
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.3), value: isPresented)
            }
        }
        .onAppear {
            withAnimation {
                isPresented.toggle()
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                closeAction()
            }
        }
    }
}

#Preview {
    BottomSheetView(closeAction: { }) { _ in
        Text("Bottom Sheet")
            .font(DFont.font(.h1, weight: .bold))
            .foregroundStyle(.white)
    }
}
