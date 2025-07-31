//
//  RecordResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct RecordResponse: Decodable {
    public let date: String
    public let contents: [Self.RecordContentResponse]?
    
    public struct RecordContentResponse: Decodable {
        public let flag: String
        public let category: String
        public let memo: String
    }
}
