//
//  RecordRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public typealias RecordContentArgument = RecordRequest.RecordElement.RecordContent

public struct RecordRequest: Encodable {
    private let userKey: String
    private let records: [Self.RecordElement]
    
    public init(
        userKey: String,
        date: String,
        records: [RecordContentArgument]?
    ) {
        self.userKey = userKey
        self.records = [
            Self.RecordElement(
                date: date,
                contents: records
            )
        ]
    }

    public struct RecordElement: Encodable {
        private let date: String
        private let contents: [RecordContent]?
        
        init(date: String, contents: [RecordContent]?) {
            self.date = date
            self.contents = contents
        }
        
        public struct RecordContent: Encodable {
            private let flag: String
            private let category: String
            private let memo: String
            
            public init(flag: String, category: String, memo: String) {
                self.flag = flag
                self.category = category
                self.memo = memo
            }
        }
    }
}

