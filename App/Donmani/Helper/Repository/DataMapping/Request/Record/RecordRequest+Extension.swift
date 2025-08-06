//
//  RecordRequest+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

import DNetwork

extension RecordRequest {
    init(userKey: String, record: Record) {
        self.init(
            userKey: userKey,
            date: record.date,
            records: record.contents?.map {
                ($0.flag.rawValue, $0.category.uppercaseTitle, $0.memo)
            }
        )
    }
}
