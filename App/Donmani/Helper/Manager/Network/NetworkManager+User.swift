//
//  NetworkManager+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    enum User {
        static func registerUser() async throws -> String {
//            let userKey = PersistentUUIDManager.shared.getPersistentUUID()
            let userKey = "test"
            let responseData: UserDTO = await self.service.requestPOST(
                path: .user,
                addtionalPath: ["register"],
                bodyData: UserDTO(userKey: userKey)
            )
            guard let userName = responseData.userName else {
                throw NetworkError.noData
            }
            return userName
        }
        
        static func updateUser(name: String) async -> String {
//            let userKey = PersistentUUIDManager.shared.getPersistentUUID()
            let userKey = "test"
            let responseData: UserDTO = await self.service.requestPUT(
                path: .user,
                addtionalPath: ["update"],
                bodyData: UserDTO(userKey: userKey, newUserName: name)
            )
            guard let userName = responseData.updatedUserName else {
                throw NetworkError.noData
            }
            return userName
        }
    }
}
