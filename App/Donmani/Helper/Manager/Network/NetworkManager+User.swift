//
//  NetworkManager+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    struct NMUser {
        let service: DNetworkService
        
        init (
            service: DNetworkService
        ) {
            self.service = service
        }
        
        func registerUser() async throws -> String {
            let responseData: UserDTO = try await self.service.requestPOST(
                path: .user,
                addtionalPath: ["register"],
                bodyData: UserDTO(userKey: NetworkManager.userKey)
            )
            guard let userName = responseData.userName else {
                throw NetworkError.noData
            }
            return userName
        }
        
        func updateUser(name: String) async throws -> String {
            let responseData: UserDTO = try await self.service.requestPUT(
                path: .user,
                addtionalPath: ["update"],
                bodyData: UserDTO(userKey: NetworkManager.userKey, newUserName: name)
            )
            guard let userName = responseData.updatedUserName else {
                throw NetworkError.noData
            }
            return userName
        }
    }
}
