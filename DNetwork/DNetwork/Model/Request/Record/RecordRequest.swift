//
//  RecordRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//


public struct RecordRequest: Encodable {
    public let userKey: String
    public let records: [RecordElementRequest]
    
    public init(userKey: String, records: [RecordElementRequest]) {
        self.userKey = userKey
        self.records = records
    }
}

public struct RecordElementRequest: Encodable {
    public let date: String
    public let contents: [RecordContentRequest]?
    
    public init(date: String, contents: [RecordContentRequest]?) {
        self.date = date
        self.contents = contents
    }
}

public struct RecordContentRequest: Encodable {
    public let flag: String
    public let category: String
    public let memo: String
    
    public init(flag: String, category: String, memo: String) {
        self.flag = flag
        self.category = category
        self.memo = memo
    }
}
