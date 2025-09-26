//
//  Record.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

struct Record {
    let day: Day
    let records: [RecordContentType: RecordContent]
    
    init(day: Day, records: [RecordContent]) {
        self.day = day
        self.records = records.reduce(into: [:]) { result, record in
            result[record.flag] = record
        }
    }
}

extension Record: Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        lhs.day == rhs.day
    }
}

extension Record: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
}

extension Record: Identifiable {
    var id: String {
        day.yyyyMMdd
    }
}
