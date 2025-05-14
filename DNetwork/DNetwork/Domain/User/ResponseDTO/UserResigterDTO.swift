//
//  UserResigterDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

public struct UserResigterDTO: Decodable {
    public let userKey: String
    public let userName: String
    public let new: Bool
}
