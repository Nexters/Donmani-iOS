//
//  RecordRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//


public struct RecordRequest: Encodable {
    public let userKey: String
    public let records: [Self.RecordElementRequest]
    
    public struct RecordElementRequest: Encodable {
        public let date: String
        public let contents: [Self.RecordContentRequest]?
        
        public struct RecordContentRequest: Encodable {
            public let flag: String
            public let category: String
            public let memo: String
        }
    }
}
