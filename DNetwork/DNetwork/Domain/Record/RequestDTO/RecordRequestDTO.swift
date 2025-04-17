//
//  RecordRequestDTO.swift
//  DNetwork
//
//  Created by 문종식 on 4/17/25.
//

public struct RecordRequestDTO: Encodable {
    public let userKey: String
    public let records: [RecordRequestDTO.RecordDTO]
    
    public struct RecordDTO: Encodable {
        public let date: String
        public let contents: [RecordRequestDTO.RecordContentDTO]?
    }
    public struct RecordContentDTO: Encodable {
        public let flag: String
        public let category: String
        public let memo: String
    }
}
