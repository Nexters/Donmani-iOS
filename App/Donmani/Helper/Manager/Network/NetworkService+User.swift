//
//  NetworkService+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkService {
    struct User {
        let request: DNetworkRequest
        let userKey: String
        
        init() {
            self.request = DNetworkRequest()
            self.userKey = NetworkService.userKey
        }
        
        func register() async throws -> String {
            let bodyData = UserDTO(userKey: userKey)
            let response: DResponse<UserDTO> = try await self.request.post(
                path: .user,
                addtionalPath: ["register"],
                bodyData: bodyData
            )
            guard let data = response.responseData?.userName else {
                throw NetworkError.noData
            }
            return data
        }
        
        func updateName(name: String) async throws -> String {
            let bodyData = UserDTO(userKey: userKey)
            let response: DResponse<UserDTO> = try await self.request.post(
                path: .user,
                addtionalPath: ["update"],
                bodyData: bodyData
            )
            guard let data = response.responseData?.updatedUserName else {
                throw NetworkError.noData
            }
            return data
        }
        
        func fetchNoticeStatus() async throws -> Bool {
            let bodyData = UserDTO(userKey: userKey)
            let response: DResponse<[String:Bool]> = try await self.request.get(
                path: .notice,
                addtionalPath: ["status", userKey]
            )
            guard let data = response.responseData?["read"] else {
                throw NetworkError.noData
            }
            return data
        }
        
        func updateNoticeStatus() async throws {
            let bodyData = UserDTO(userKey: userKey)
            let response: DResponse<Data> = try await self.request.put(
                path: .notice,
                addtionalPath: ["status", userKey],
                bodyData: Data()
            )
        }
    }
}
