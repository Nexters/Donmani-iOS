//
//  UserRequestDTO.swift
//  DNetwork
//
//  Created by 문종식 on 4/17/25.
//

public struct UserRequestDTO: Encodable {
    public let userKey: String
    public let newUserName: String?
    
    init(userKey: String, newUserName: String? = nil) {
        self.userKey = userKey
        self.newUserName = newUserName
    }
}
