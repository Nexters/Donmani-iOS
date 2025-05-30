//
//  Record.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

struct Record: Equatable {
    var date: String
    var contents: [RecordContent]?
    
    static let previewData: [Record] = {
        let dateString = DateManager.shared.getFormattedDate(for: .today)
        let dateComponents = dateString.components(separatedBy: "-").compactMap(Int.init)
        return (1...31).map { d in
            let day = String(format: "%02d", d)
            let month = String(format: "%02d", dateComponents[1])
            return Record(date: "\(dateComponents[0])-\(month)-\(day)")
        }
    }()
}
