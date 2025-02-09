//
//  Text+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/4/25.
//

import SwiftUI
import DesignSystem

public extension Text {
    func font(_ style: DFontStyle, _ weight: DFontWeight = .regular) -> some View {
        self.modifier(DFontModifier(style: style, weight: weight))
    }
}

import SwiftUI

struct TestContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: ChildView()) {
                Text("Go to Next View")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct ChildView: View {
    @State private var showOpacityElement = false
    @State private var showMoveElement = false
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            ZStack {
                VStack {
                    Text("Fade-in Element")
                        .font(.largeTitle)
                        .opacity(showOpacityElement ? 1 : 0)  // ✅ Opacity 애니메이션
                        .animation(.easeInOut(duration: 1), value: showOpacityElement)
                    Spacer()
                }
                
                if (showOpacityElement){
                    Text("Slide-in Element")
                        .font(.title)
                        .frame(width: 100, height: 200)
                        .background(.blue.opacity(0.3))
                        .transition(.move(edge: .bottom))  // ✅ Move 애니메이션
                        .animation(.easeInOut(duration: 1), value: showOpacityElement)
                }
            }
        }
        .onAppear {
            withAnimation {
                showOpacityElement = true
            }
        }
    }
}

#Preview {
    TestContentView()
}
