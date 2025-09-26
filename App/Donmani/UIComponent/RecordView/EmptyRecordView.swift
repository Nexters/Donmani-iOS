//
//  EmptyRecordView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem

struct EmptyRecordView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: .s3,
                style: .continuous
            )
            .fill(DColor.empty)
            VStack(alignment: .center, spacing: .defaultLayoutPadding) {
                DText("오늘은 무소비 데이!")
                    .style(.h2, .bold, .gray95)
                DImage(.emptyRecord).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth / 2)
            }
            .padding(.defaultLayoutPadding + 8)
        }
        .frame(height: 256)
    }
}

#Preview {
    EmptyRecordView()
}
