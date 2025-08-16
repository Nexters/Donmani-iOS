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
            day: Day(yyyymmdd: self.date),
            records: self.contents?.map { $0.toDomain() } ?? []
        )
    }
}

extension RecordResponse.RecordContentResponse {
    func toDomain() -> RecordContent {
        RecordContent(
            flag: RecordContentType(rawValue: self.flag),
            category: RecordCategory(rawValue: self.category.lowercased()) ?? .none,
            memo: self.memo
        )
    }
}
