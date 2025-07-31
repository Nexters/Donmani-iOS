//
//  ResponseWrapper.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct ResponseWrapper<D: Decodable>: Decodable {
    public let statusCode: Int
    public let responseMessage: String
    public let responseData: D?
}
