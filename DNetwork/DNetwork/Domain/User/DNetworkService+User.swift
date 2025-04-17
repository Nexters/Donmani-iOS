//
//  DNetworkService+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

extension DNetworkService {
    public struct User {
        let request: DNetworkRequest
        let userKey: String
        
        init() {
            self.request = DNetworkRequest()
            self.userKey = DNetworkService.userKey
        }
        
        public func register() async throws -> String {
            let bodyData = UserRequestDTO(userKey: userKey)
            let response: DResponse<UserResigterDTO> = try await self.request.post(
                path: .user,
                addtionalPath: ["register"],
                bodyData: bodyData
            )
            guard let data = response.responseData?.userName else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func updateName(name: String) async throws -> String {
            let bodyData = UserRequestDTO(userKey: userKey, newUserName: name)
            let response: DResponse<UserUpdateDTO> = try await self.request.post(
                path: .user,
                addtionalPath: ["update"],
                bodyData: bodyData
            )
            guard let data = response.responseData?.updatedUserName else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func fetchNoticeStatus() async throws -> Bool {
            let response: DResponse<[String:Bool]> = try await self.request.get(
                path: .notice,
                addtionalPath: ["status", userKey]
            )
            guard let data = response.responseData?["read"] else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func updateNoticeStatus() async throws {
            let response: DResponse<Data> = try await self.request.put(
                path: .notice,
                addtionalPath: ["status", userKey],
                bodyData: Data()
            )
        }
    }
}
