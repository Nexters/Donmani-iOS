//
//  DNetworkService+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

public extension DNetworkService {
    struct User {
        let request: DNetworkRequest
        let userKey: String
        
        public init() {
            self.request = DNetworkRequest()
            self.userKey = DNetworkService.userKey
        }
        
        public func register() async throws -> String {
            let bodyData = UserRequestDTO(userKey: userKey)
            let response: DResponse<UserResigterDTO> = try await self.request.post(
                path: .user,
                additionalPath: ["register"],
                bodyData: bodyData
            )
            guard let data = response.responseData?.userName else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func update(name: String) async throws -> String {
            let bodyData = UserRequestDTO(userKey: userKey, newUserName: name)
            let response: DResponse<UserUpdateDTO> = try await self.request.post(
                path: .user,
                additionalPath: ["update"],
                bodyData: bodyData
            )
            guard let data = response.responseData?.updatedUserName else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func fetchNoticeStatus() async throws -> Bool {
            let response: [String:Bool] = try await self.request.get(
                path: .notice,
                additionalPath: ["status", userKey]
            )
            guard let data = response["read"] else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func updateNoticeStatus() async throws {
            let _: DResponse<Data> = try await self.request.put(
                path: .notice,
                additionalPath: ["status", userKey],
                bodyData: Data()
            )
        }
        
        public func fetchRewardStatus() async throws -> Bool {
            let response: [String: Bool] = try await self.request.get(
                path: .reward,
                additionalPath: ["status", userKey]
            )
            guard let data = response["checked"] else {
                throw NetworkError.noData
            }
            return data
        }
        
        public func updateRewardStatus() async throws {
            let _: DResponse<Data> = try await self.request.put(
                path: .reward,
                additionalPath: ["status", userKey],
                bodyData: Data()
            )
        }
    }
}
