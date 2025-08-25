//
//  UserAPI.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct UserAPI {
    private let request = NetworkRequest()
    
    public init() { }
    
    /// 사용자 등록
    public func postRegisterUser(userKey: String) async throws -> UserResponse {
        let result: ResponseWrapper<UserResponse> = try await request.post(
            path: .user,
            additionalPaths: ["register"],
            bodyData: ["userKey": userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 사용자 정보 업데이트
    public func postUpdateUser(userKey: String, newUserName: String) async throws -> UserUpdateResponse {
        let result: ResponseWrapper<UserUpdateResponse> = try await request.post(
            path: .user,
            additionalPaths: ["register"],
            bodyData: [
                "userKey": userKey,
                "newUserName": newUserName
            ]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// FCM 토큰 업데이트
    public func postUpdateToken(userKey: String, token: String) async throws -> String {
        try await request.post(
            path: nil,
            additionalPaths: [userKey, "token"],
            bodyData: token
        )
    }
    
    /// 마지막 로그인 업데이트
    public func putLastLogin(userKey: String) async throws {
        let result: ResponseWrapper<EmptyResponse> = try await request.get(
            path: .user,
            additionalPaths: ["last-login", userKey]
        )
        guard let _ = result.responseData else {
            throw NetworkError.noData
        }
    }
    
    /// 공지사항 확인 상태 업데이트
    public func putNoticeStatus(userKey: String) async throws {
        let _: EmptyResponse = try await request.put(
            path: .notice,
            additionalPaths: ["status", userKey]
        )
    }
    
    /// 공지사항 확인 상태 조회
    public func getNoticeStatus(userKey: String) async throws -> NoticeStatusResponse {
        let result: ResponseWrapper<NoticeStatusResponse> = try await request.get(
            path: .notice,
            additionalPaths: ["status", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 새 리워드 아이템 확인 상태 업데이트
    public func putRewardStatus(userKey: String) async throws {
        let _: EmptyResponse = try await request.put(
            path: .reward,
            additionalPaths: ["status", userKey]
        )
    }
    
    /// 새 리워드 아이템 확인 상태 조회
    public func getRewardStatus(userKey: String) async throws -> RewardStatusResponse {
        let result: ResponseWrapper<RewardStatusResponse> = try await request.get(
            path: .reward,
            additionalPaths: ["status", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
}
