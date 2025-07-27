//
//  UserRespository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

final actor UserRespository {
    let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    /// 사용자 등록
    public func postRegisterUser(userKey: String) async throws -> User {
        let response = try await self.service.postRegisterUser(userKey: userKey)
        return response.toDomain()
    }
    
    /// 사용자 정보 업데이트
    public func postUpdateUser(userKey: String, newUserName: String) async throws -> User {
        let response = try await self.service.postUpdateUser(userKey: userKey, newUserName: newUserName)
        return response.toDomain()
    }
    
    /// 마지막 로그인 업데이트
    public func putLastLogin(userKey: String) async throws {
        try await self.service.putLastLogin(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 업데이트
    public func putNoticeStatus(userKey: String) async throws {
        try await self.service.putNoticeStatus(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 조회
    func getNoticeStatus(userKey: String) async throws -> Bool {
        let response = try await self.service.getNoticeStatus(userKey: userKey)
        let isRead = response.read
        return isRead
    }
    
    /// 새 리워드 아이템 확인 상태 업데이트
    func putRewardStatus(userKey: String) async throws {
        try await self.service.putRewardStatus(userKey: userKey)
    }
    
    /// 새 리워드 아이템 확인 상태 조회
    func getRewardStatus(userKey: String) async throws -> Bool {
        let response = try await self.service.getRewardStatus(userKey: userKey)
        let hasNewBadge = response.checked
        return hasNewBadge
    }
}
