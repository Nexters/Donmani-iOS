//
//  RecordResponse+Extension.swift
//  Donmani
//
//  Created by Gabia on 7/30/25.
//

import DNetwork

extension RecordResponse {
    func toDomain() -> NewRecord {
        NewRecord(
            day: Day(yyyymmdd: self.date),
            records: self.contents?.map { $0.toDomain() } ?? []
        )
    }
}

extension RecordResponse.RecordContentResponse {
    func toDomain() -> NewRecordContent {
        NewRecordContent(
            flag: RecordContentType(rawValue: self.flag),
            category: NewRecordCategory(rawValue: self.category.lowercased()) ?? .none,
            memo: self.memo
        )
    }
}
