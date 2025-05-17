//
//  BottomSheetView.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem

struct BottomSheetView<Content: View>: View {
    let isActiveClose: Bool
    let closeAction: () -> Void
    let content: (@escaping (@escaping () -> Void) -> Void) -> Content
    @State private var isPresented = false
    
    init(
        isActiveClose: Bool = true,
        closeAction: @escaping () -> Void,
        @ViewBuilder _ content: @escaping (@escaping (@escaping () -> Void) -> Void) -> Content
    ) {
        self.isActiveClose = isActiveClose
        self.closeAction = closeAction
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(isPresented ? 0.6 : 0)
                .onTapGesture {
                    if isActiveClose {
                        dismiss(nil)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: isPresented)
                .ignoresSafeArea()
            if isPresented {
                VStack {
                    Spacer(minLength: 10)
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            if isActiveClose {
                                Button {
                                    dismiss(nil)
                                } label: {
                                    DImage(.circleClose).image
                                        .resizable()
                                        .frame(width: .s2, height: .s2)
                                }
                            }
                        }
                        .padding(.bottom, .s3)
                        
                        content { action in
                            dismiss(action)
                        }
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
            UINavigationController.isBlockSwipe = true
        }
    }
    
    private func dismiss(_ action: (() -> Void)?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        withAnimation {
            isPresented.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let action = action {
                    action()
                } else {
                    closeAction()
                }
            }
        }
    }
}

#Preview {
    BottomSheetView(closeAction: { }) { _ in
        DText("Bottom Sheet")
            .style(.h1, .bold, .white)
    }
}
