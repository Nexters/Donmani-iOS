//
//  UserResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct UserResponse: Decodable {
    public let userKey: String
    public let userName: String
    public let new: Bool
}
