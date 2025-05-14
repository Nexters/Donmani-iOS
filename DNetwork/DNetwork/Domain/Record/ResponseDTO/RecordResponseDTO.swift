//
//  RecordResponseDTO.swift
//  DNetwork
//
//  Created by 문종식 on 4/17/25.
//

public struct RecordResponseDTO: Decodable {
    public let userKey: String
    public let records: [RecordResponseDTO.RecordDTO]?
    
    public struct RecordDTO: Decodable {
        public let date: String
        public let contents: [RecordResponseDTO.RecordContentDTO]?
    }
    public struct RecordContentDTO: Decodable {
        public let flag: String
        public let category: String
        public let memo: String
    }
}
