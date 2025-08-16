//
//  UserRespository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork
import ComposableArchitecture

protocol UserRespository {
    func registerUser() async throws -> User
    func getUserName() -> String
    func updateUserName(newUserName: String) async throws -> User
    func postUpdateToken(token: String) async throws -> String
    func putLastLogin() async throws
    func putNoticeStatus() async throws
    func getNoticeStatus() async throws -> Bool
    func putRewardStatus() async throws
    func getRewardStatus() async throws -> Bool
}

struct DefaultUserRespository: UserRespository {
    private let dataSource = UserAPI()
    private var keychainDataSource: KeychainDataSource
//    @Dependency(\.keychainDataSource)
    
    init(keychainDataSource: KeychainDataSource) {
        self.keychainDataSource = keychainDataSource
    }
    
    /// 사용자 이름
    private var userName: String {
        keychainDataSource.getUserName()
    }
    
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    /// 사용자 등록
    func registerUser() async throws -> User {
        let response = try await dataSource.postRegisterUser(userKey: userKey)
        let user = response.toDomain()
        keychainDataSource.setUserName(name: user.userName)
        return user
    }
    
    func getUserName() -> String {
        userName
    }
    
    /// 사용자 정보 업데이트
    func updateUserName(newUserName: String) async throws -> User {
        let response = try await dataSource.postUpdateUser(userKey: userKey, newUserName: newUserName)
        let user = response.toDomain()
        keychainDataSource.setUserName(name: user.userName)
        return user
    }
    
    
    /// FCM 토큰 업데이트
    func postUpdateToken(token: String) async throws -> String {
        try await dataSource.postUpdateToken(userKey: userKey, token: token)
    }
    
    /// 마지막 로그인 업데이트
    func putLastLogin() async throws {
        try await dataSource.putLastLogin(userKey: userKey)
    }
    
    /// 공지사항 확인 상태 업데이트
    func putNoticeStatus() async throws {
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

extension DependencyValues {
    private enum UserRespositoryKey: DependencyKey {
        static let liveValue: UserRespository = {
            @Dependency(\.keychainDataSource) var keychainDataSource
            return DefaultUserRespository(
                keychainDataSource: keychainDataSource
            )
        }()
    }
    
    var userRespository: UserRespository {
        get { self[UserRespositoryKey.self] }
        set { self[UserRespositoryKey.self] = newValue }
    }
}
