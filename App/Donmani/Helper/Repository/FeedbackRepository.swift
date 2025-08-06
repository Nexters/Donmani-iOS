//
//  FeedbackRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork
import ComposableArchitecture

final actor FeedbackRepository {
    private let dataSource = FeedbackAPI()
    @Dependency(\.keychainDataSource) var keychainDataSource
    
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    /// 피드백 상태(미확인 리워드, 첫 오픈 여부, 리워드 개수)
    public func getFeedbackState() async throws -> FeedbackInfo {
        let response = try await self.dataSource.getFeedbackState(userKey: userKey)
        return response.toDomain()
    }
    
    /// 피드백 카드 정보
    public func getFeedbackCard() async throws -> FeedbackCard {
        let response = try await self.dataSource.getFeedbackCard(userKey: userKey)
        return response.toDomain()
    }
}
