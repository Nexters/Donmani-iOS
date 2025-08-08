//
//  UserRespository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork
import ComposableArchitecture

final actor UserRespository {
    private let dataSource = UserAPI()
    @Dependency(\.keychainDataSource) private var keychainDataSource
    
    /// 사용자 이름
    private var userName: String {
        get { keychainDataSource.getUserName() }
        set { keychainDataSource.setUserName(name: newValue) }
    }
    
    /// 사용자 ID
    var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    /// 사용자 등록
    public func registerUser() async throws -> User {
        let response = try await dataSource.postRegisterUser(userKey: userKey)
        let user = response.toDomain()
        userName = user.userName
        return user
    }
    
    /// 사용자 정보 업데이트
    public func updateUserName(newUserName: String) async throws -> User {
        let response = try await dataSource.postUpdateUser(userKey: userKey, newUserName: newUserName)
        userName = newUserName
        return response.toDomain()
    }
    
    /// FCM 토큰 업데이트
    public func postUpdateToken(token: String) async throws -> String {
        try await dataSource.postUpdateToken(userKey: userKey, token: token)
    }
    
    /// 마지막 로그인 업데이트
    public func putLastLogin() async throws {
        try await dataSource.putLastLogin(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 업데이트
    public func putNoticeStatus() async throws {
        try await dataSource.putNoticeStatus(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 조회
    func getNoticeStatus() async throws -> Bool {
        let response = try await dataSource.getNoticeStatus(userKey: userKey)
        let isRead = response.read
        return isRead
    }
    
    /// 새 리워드 아이템 확인 상태 업데이트
    func putRewardStatus() async throws {
        try await dataSource.putRewardStatus(userKey: userKey)
    }
    
    /// 새 리워드 아이템 확인 상태 조회
    func getRewardStatus() async throws -> Bool {
        let response = try await dataSource.getRewardStatus(userKey: userKey)
        let hasNewBadge = response.checked
        return hasNewBadge
    }
}
