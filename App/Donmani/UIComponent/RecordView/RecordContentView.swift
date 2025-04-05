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
//    let action: (() -> Void)?
    let isEditable: Bool
    
//    init(record: RecordContent, action: (() -> Void)? = nil) {
//        self.record = record
//        self.action = action
//    }
    
    init(
        record: RecordContent,
        isEditable: Bool = true
    ) {
        self.record = record
        self.isEditable = isEditable
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(record.category.title)
                    .font(DFont.font(.h3, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                if isEditable {
                    DImage(.edit).image
                        .resizable()
                        .frame(width: .s4, height: .s4)
                }
            }
            HStack(spacing: 12) {
                VStack {
                    ZStack {
                        record.category.image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    DImage(.smallStar).image
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(record.category.color)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay {
                                            DImage(.starSingleHighlighter).image
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fit)
                                        }
                                        .frame(width: .s2)
                                        .offset(x: 0, y: 8)
                                }
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(width: 78)
                    Spacer()
                }
                VStack(spacing: 0) {
                    Text(record.memo)
                        .font(DFont.font(.b1, weight: .medium))
                        .foregroundStyle(DColor(.gray95).color)
                        .lineLimit(10)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
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
    )
}
