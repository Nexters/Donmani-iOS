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
                DText(record.category.title)
                    .style(.h3, .bold, .white)
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
                        record
                            .category
                            .image
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
                    DText(record.memo)
                        .style(.b1, .medium, .gray95)
                        .lineLimit(10)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 3)
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
            category: .greed,
            memo: "하하 망했어요"
        )
    )
}
