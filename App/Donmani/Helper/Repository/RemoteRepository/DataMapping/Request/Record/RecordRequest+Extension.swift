//
//  RecordRequest+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

import DNetwork

extension RecordRequest {
    static func from(userKey: String, record: Record) -> RecordRequest {
        RecordRequest(
            userKey: userKey,
            records: [
                RecordElementRequest(
                    date: record.date,
                    contents: record.contents?.map {
                        RecordContentRequest(
                            flag: $0.flag.rawValue,
                            category: $0.category.uppercaseTitle,
                            memo: $0.memo
                        )
                    }
                )
            ]
        )
    }
}
