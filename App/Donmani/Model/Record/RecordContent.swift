//
//  RecordContent.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

struct RecordContent {
    var flag: RecordContentType
    var category: RecordCategory
    var memo: String
    
    init(
        flag: RecordContentType,
        category: RecordCategory,
        memo: String
    ) {
        self.flag = flag
        self.category = category
        self.memo = memo
    }
}
