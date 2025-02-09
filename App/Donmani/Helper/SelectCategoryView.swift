//
//  SelectCategoryView.swift
//  Donmani
//
//  Created by 문종식 on 2/7/25.
//

import SwiftUI
import DesignSystem

struct SelectCategoryView: View {
    let closeAction: () -> Void
    let category: [RecordCategory]
    let type: RecordContentType
    
    @State private var showAnimation = false
    
    let columns = Array(
        repeating: GridItem(.flexible(minimum: 100, maximum: 500)),
        count: 3
    )
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(showAnimation ? 0.6 : 0)
                .onTapGesture {
                    dismiss()
                }
                .animation(.easeInOut(duration: 0.3), value: showAnimation)
                .ignoresSafeArea()
            
            if showAnimation {
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
                        
                        Text("어떤 \(type.title)였나요?")
                            .font(DFont.font(.h2, weight: .bold))
                            .foregroundStyle(.white)
                        LazyVGrid(columns: columns, spacing: .s3) {
                            ForEach(category.indices, id: \.self) { i in
                                Button{
                                    
                                } label: {
                                    VStack(spacing: 4) {
                                        DImage(.tempImage).image
                                            .frame(width: 62, height: 62)
                                        Text(category[i].title)
                                            .font(DFont.font(.b2, weight: .semibold))
                                            .foregroundStyle(DColor(.deepBlue90).color)
                                    }
                                }
                                .padding(.horizontal, 15)
                            }
                        }
                        .padding(.vertical , 24)
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(
                                    cornerRadius: 16.0,
                                    style: .continuous
                                )
                                .fill(DColor(.deepBlue20).color)
                                .frame(height: 58)
                                Text("완료")
                                    .font(DFont.font(.h3, weight: .bold))
                                    .foregroundStyle(DColor(.deepBlue70).color)
                            }
                        }
                    }
                    .padding(.horizontal, .defaultLayoutPadding)
                    .padding(.vertical, 20)
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
                .animation(.easeOut(duration: 0.3), value: showAnimation)
            }
        }
        .onAppear {
            withAnimation {
                showAnimation.toggle()
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            showAnimation.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                closeAction()
            }
        }
    }
}

#Preview {
    SelectCategoryView(
        closeAction: { },
        category: GoodCategory.allCases.map(RecordCategory.init),
        type: .good
    )
}
