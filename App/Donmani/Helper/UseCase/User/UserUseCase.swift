//
//  UserUseCase.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import ComposableArchitecture

protocol UserUseCase {
    var userName: String { get }
    func registerUser() async throws -> User
    func update(newUserName: String) async throws -> User
    func update(token: String) async throws -> String
    func updateLastLogin() async throws
    func updateNoticeReadStatus() async throws
    func getNoticeReadStatus() async throws -> Bool
    func updateNewRewardReadStatus() async throws
    func getRewardReadStatus() async throws -> Bool
}

struct DefaultUserUseCase: UserUseCase {
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// 사용자 이름
    var userName: String {
        userRepository.getUserName()
    }
    
    /// 사용자 등록
    func registerUser() async throws -> User {
        try await userRepository.registerUser()
    }
    
    /// 사용자 정보 업데이트
    func update(newUserName: String) async throws -> User {
        try await userRepository.updateUserName(newUserName: newUserName)
    }
    
    /// FCM 토큰 업데이트
    func update(token: String) async throws -> String {
        try await userRepository.postUpdateToken(token: token)
    }
    
    /// 마지막 로그인 업데이트
    func updateLastLogin() async throws {
        try await userRepository.putLastLogin()
    }
    
    /// 공지사항 확인 상태 업데이트
    func updateNoticeReadStatus() async throws {
        try await userRepository.putNoticeStatus()
    }
    
    /// 공지사항 확인 상태 조회
    func getNoticeReadStatus() async throws -> Bool {
        try await userRepository.getNoticeStatus()
    }
    
    /// 새 리워드 아이템 확인 상태 업데이트
    func updateNewRewardReadStatus() async throws {
        try await userRepository.putRewardStatus()
    }
    
    /// 새 리워드 아이템 확인 상태 조회
    func getRewardReadStatus() async throws -> Bool {
        try await userRepository.getRewardStatus()
    }
}

extension DependencyValues {
    private enum UserUseCaseKey: DependencyKey {
        static let liveValue: UserUseCase = {
            @Dependency(\.userRepository) var userRepository
            return DefaultUserUseCase(
                userRepository: userRepository
            )
        }()
    }
    
    var userUseCase: UserUseCase {
        get { self[UserUseCaseKey.self] }
        set { self[UserUseCaseKey.self] = newValue }
    }
}
