//
//  FeedbackRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork
import ComposableArchitecture

protocol FeedbackRepository {
    func getFeedbackState() async throws -> FeedbackInfo
    func getFeedbackCard() async throws -> FeedbackCard
}

struct DefaultFeedbackRepository: FeedbackRepository {
    private let dataSource = FeedbackAPI()
    private var keychainDataSource: KeychainDataSource
    
    init(keychainDataSource: KeychainDataSource) {
        self.keychainDataSource = keychainDataSource
    }
    
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    /// 피드백 상태(미확인 리워드, 첫 오픈 여부, 리워드 개수)
    public func getFeedbackState() async throws -> FeedbackInfo {
        let response = try await dataSource.getFeedbackState(userKey: userKey)
        return response.toDomain()
    }
    
    /// 피드백 카드 정보
    public func getFeedbackCard() async throws -> FeedbackCard {
        let response = try await dataSource.getFeedbackCard(userKey: userKey)
        return response.toDomain()
    }
}

extension DependencyValues {
    private enum FeedbackRepositoryKey: DependencyKey {
        static let liveValue: FeedbackRepository = {
                @Dependency(\.keychainDataSource) var keychainDataSource
            return DefaultFeedbackRepository(
                keychainDataSource: keychainDataSource
            )
        }()
    }
    
    var feedbackRepository: FeedbackRepository {
        get { self[FeedbackRepositoryKey.self] }
        set { self[FeedbackRepositoryKey.self] = newValue }
    }
}
