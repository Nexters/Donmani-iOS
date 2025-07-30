//
//  RecordRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//


public struct RecordRequest: Encodable {
    public let userKey: String
    public let records: [Self.RecordElement]
    
    public init(
        userKey: String,
        date: String,
        records: [Self.RecordContentTriple]?
    ) {
        self.userKey = userKey
        self.records = [
            Self.RecordElement(
                date: date,
                contents: records
            )
        ]
    }
    
    public typealias RecordContentTriple = (flag: String, category: String, memo: String)
    
    public struct RecordElement: Encodable {
        private let date: String
        private let contents: [RecordContent]?
        
        init(date: String, contents: [RecordContentTriple]?) {
            self.date = date
            self.contents = contents?.map {
                RecordContent(
                    flag: $0.flag,
                    category: $0.category,
                    memo: $0.memo
                )
            }
        }
        
        public struct RecordContent: Encodable {
            private let flag: String
            private let category: String
            private let memo: String
            
            init(flag: String, category: String, memo: String) {
                self.flag = flag
                self.category = category
                self.memo = memo
            }
        }
    }
}

