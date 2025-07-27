//
//  UserService.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct UserService {
    private let request: NetworkRequest
    
    public init(request: NetworkRequest) {
        self.request = request
    }
    
    /// 사용자 등록
    public func postRegisterUser(userKey: String) async throws -> UserResponse {
        let result: DResponse<UserResponse> = try await request.post(
            path: .user,
            addtionalPaths: ["register"],
            bodyData: ["userKey": userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 사용자 정보 업데이트
    public func postUpdateUser(userKey: String, newUserName: String) async throws -> UserUpdateResponse {
        let result: DResponse<UserUpdateResponse> = try await request.post(
            path: .user,
            addtionalPaths: ["register"],
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
    
    /// 마지막 로그인 업데이트
    public func putLastLogin(userKey: String) async throws {
        let result: DResponse<EmptyResponse> = try await request.get(
            path: .user,
            addtionalPaths: ["last-login", userKey]
        )
        guard let _ = result.responseData else {
            throw NetworkError.noData
        }
    }
    
    /// 공지사항 확인 상태 업데이트
    public func putNoticeStatus(userKey: String) async throws {
        let _: EmptyResponse = try await request.put(
            path: .notice,
            addtionalPaths: ["status", userKey]
        )
    }
    
    /// 공지사항 확인 상태 조회
    func getNoticeStatus(userKey: String) async throws -> NoticeStatusResponse {
        let result: DResponse<NoticeStatusResponse> = try await request.get(
            path: .notice,
            addtionalPaths: ["status", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 새 리워드 아이템 확인 상태 업데이트
    func putRewardStatus(userKey: String) async throws {
        let _: EmptyResponse = try await request.put(
            path: .reward,
            addtionalPaths: ["status", userKey]
        )
    }
    
    /// 새 리워드 아이템 확인 상태 조회
    func getRewardStatus(userKey: String) async throws -> RewardStatusResponse {
        let result: DResponse<RewardStatusResponse> = try await request.get(
            path: .reward,
            addtionalPaths: ["status", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
}
