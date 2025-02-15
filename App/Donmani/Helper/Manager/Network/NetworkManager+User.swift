//
//  NetworkManager+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    struct User {
        let service: DNetworkService
        let userKey: String
        
        init (
            service: DNetworkService,
            userKey: String
        ) {
            self.service = service
            self.userKey = userKey
        }
        
        func registerUser() async throws -> String {
            //            let userKey = PersistentUUIDManager.shared.getPersistentUUID()
            let responseData: UserDTO = try await self.service.requestPOST(
                path: .user,
                addtionalPath: ["register"],
                bodyData: UserDTO(userKey: userKey)
            )
            guard let userName = responseData.userName else {
                throw NetworkError.noData
            }
            return userName
        }
        
        func updateUser(name: String) async throws -> String {
//            let userKey = PersistentUUIDManager.shared.getPersistentUUID()
            let responseData: UserDTO = try await self.service.requestPUT(
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
