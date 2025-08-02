//
//  RecordDataSource.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

final actor RecordDataSource {
    private typealias MonthlyRecord = [Int: [Record]]
    private var data: [Int: MonthlyRecord] = [:]
    
    func save(_ record: Record) {
        let year = record.year
        let month = record.month
        data[year, default: MonthlyRecord()][month, default: []].append(record)
    }
    
    func saveRecords(_ records: [Record]) {
        records.forEach { save($0) }
    }
    
    func loadRecords(year: Int, month: Int) -> [Record]? {
        guard let yearRecords = data[year] else { return nil }
        guard let monthRecords = yearRecords[month] else { return nil }
        return monthRecords
    }
}
