//
//  RecordRequestDTO.swift
//  DNetwork
//
//  Created by 문종식 on 4/17/25.
//

public struct RecordRequestDTO: Encodable {
    public let userKey: String
    public let records: [RecordRequestDTO.RecordDTO]
    public init(userKey: String, records: [RecordRequestDTO.RecordDTO]) {
        self.userKey = userKey
        self.records = records
    }
    
    public struct RecordDTO: Encodable {
        public let date: String
        public let contents: [RecordRequestDTO.RecordContentDTO]?
        public init(date: String, contents: [RecordRequestDTO.RecordContentDTO]?) {
            self.date = date
            self.contents = contents
        }
    }
    
    public struct RecordContentDTO: Encodable {
        public let flag: String
        public let category: String
        public let memo: String
        public init(flag: String, category: String, memo: String) {
            self.flag = flag
            self.category = category
            self.memo = memo
        }
    }
}
