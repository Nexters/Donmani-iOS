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
            date: record.day.yyyyMMdd,
            records: [
                record.records[.good].map { item -> RecordContentArgument in
                    RecordContentArgument(
                        flag: item.flag.rawValue,
                        category: item.category.uppercaseValue,
                        memo: item.memo
                    )
                },
                record.records[.good].map { item -> RecordContentArgument in
                    RecordContentArgument(
                        flag: item.flag.rawValue,
                        category: item.category.uppercaseValue,
                        memo: item.memo
                    )
                },
            ].compactMap{ $0 }
        )
    }
}
