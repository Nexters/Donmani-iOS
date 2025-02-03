//
//  Record.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

import Foundation

struct RecordDTO {
    var records: [Record]?
}

struct Record {
    var date: Date
    var contents: [Content]?
}
