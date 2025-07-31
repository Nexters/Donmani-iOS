//
//  UserUpdateResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct UserUpdateResponse: Decodable {
    public let userKey: String
    public let updatedUserName: String
}
