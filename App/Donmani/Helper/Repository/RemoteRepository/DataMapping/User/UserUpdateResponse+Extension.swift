//
//  UserUpdateResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

extension UserUpdateResponse {
    func toDomain() -> User {
        User(
            userKey: self.userKey,
            userName: self.updatedUserName,
            new: false
        )
    }
}
