//
//  SelectCategoryView.swift
//  Donmani
//
//  Created by 문종식 on 2/7/25.
//

import SwiftUI
import DesignSystem

struct SelectCategoryView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(DColor(.deepBlue60).color)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 32,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 32
                    )
                )
            VStack {
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        DImage(.close).image
                            .resizable()
                            .frame(width: .s2, height: .s2)
                    }
                }
                Text("어떤 행복 소비였나요?")
                    .font(DFont.font(.h2, weight: .bold))
                    .foregroundStyle(.white)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(1..<12) { buttonText in
                        Button{
                            
                        } label: {
                            Text(buttonText)
                                .font(DFont.font(.b2, weight: .semibold))
                                .foregroundStyle(DColor(.deepBlue90).color)
                        }
                    }
                }
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
}

#Preview {
    SelectCategoryView()
}
