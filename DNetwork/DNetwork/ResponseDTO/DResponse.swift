//
//  DResponse.swift
//  DNetwork
//
//  Created by 문종식 on 4/15/25.
//

import Foundation

public struct DResponse<D: Decodable>: Decodable {
    public let statusCode: Int
    public let responseMessage: String
    public let responseData: D?
}
