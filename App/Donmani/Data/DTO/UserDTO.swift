//
//  UserDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

struct UserDTO: Codable {
    let userKey: String
    var userName: String? = nil
    var updatedUserName: String? = nil
    var newUserName: String? = nil
    var new: Bool = false
    
    init(userKey: String) {
        self.userKey = userKey
    }
    
    init(userKey: String, newUserName: String) {
        self.userKey = userKey
        self.newUserName = newUserName
    }
}
