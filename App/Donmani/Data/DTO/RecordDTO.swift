//
//  RecordDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

struct RecordDTO: Codable {
    var date: String
    var contents: [RecordContentDTO]?
}
