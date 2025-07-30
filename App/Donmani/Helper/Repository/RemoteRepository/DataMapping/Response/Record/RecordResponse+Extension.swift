//
//  RecordResponse+Extension.swift
//  Donmani
//
//  Created by Gabia on 7/30/25.
//

import DNetwork

extension RecordResponse {
    func toDomain() -> Record {
        Record(
            date: self.date,
            contents: self.contents?.map {
                RecordContent(
                    flag: RecordContentType(rawValue: $0.flag),
                    category: RecordCategory(rawValue: $0.category),
                    memo: $0.memo
                )
            }
        )
    }
}
