//
//  UserDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

struct UserDTO: Codable {
    let userKey: String
    let userName: String? = nil
    let updatedUserName: String? = nil
    let newUserName: String? = nil
}
