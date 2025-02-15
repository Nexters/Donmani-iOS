//
//  RecordContentView.swift
//  Donmani
//
//  Created by 문종식 on 2/15/25.
//

import SwiftUI
import DesignSystem

struct RecordContentView: View {
    let record: RecordContent
    let action: (() -> Void)?
    
    init(record: RecordContent, action: (() -> Void)? = nil) {
        self.record = record
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(record.category.title)
                    .font(DFont.font(.h3, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                if let action {
                    Button {
                        action()
                    } label: {
                        DImage(.edit).image
                            .resizable()
                            .frame(width: .s4, height: .s4)
                    }
                }
            }
            HStack(spacing: 12) {
                record.category.image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 78)
                Text(record.memo)
                    .font(DFont.font(.b1, weight: .medium))
                    .foregroundStyle(DColor(.gray95).color)
                    .lineLimit(10)
            }
        }
        .padding(.defaultLayoutPadding)
    }
}

#Preview {
    RecordContentView(
        record: RecordContent(
            flag: .bad,
            category: RecordCategory(BadCategory.greed),
            memo: "망했어요"
        )
    ) {
        
    }
}
