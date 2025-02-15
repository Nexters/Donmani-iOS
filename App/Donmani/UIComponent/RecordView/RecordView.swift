//
//  RecordView.swift
//  Donmani
//
//  Created by 문종식 on 2/15/25.
//

import SwiftUI

struct RecordView: View {
    let record: RecordContent
    let action: (() -> Void)?
    
    init(record: RecordContent, action: (() -> Void)? = nil) {
        self.record = record
        self.action = action
    }
    
    var body: some View {
        RecordContentView(record: record, action: action)
        .background {
            RecordBackgroundView(record.category.color)
        }
    }
}

#Preview {
    RecordView(
        record: RecordContent(
            flag: .good,
            category: RecordCategory(GoodCategory.flex),
            memo: "아이맥 일시불 가보자고"
        )
    )
}
