//
//  FeedbackRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

final actor FeedbackRepository {
    let service: FeedbackService
    
    init(service: FeedbackService) {
        self.service = service
    }
    
    /// 피드백 상태(미확인 리워드, 첫 오픈 여부, 리워드 개수)
    public func getFeedbackState(userKey: String) async throws -> FeedbackInfo {
        let response = try await self.service.getFeedbackState(userKey: userKey)
        return response.toDomain()
    }
    
    /// 피드백 카드 정보
    public func getFeedbackCard(userKey: String) async throws -> FeedbackCard {
        let response = try await self.service.getFeedbackCard(userKey: userKey)
        return response.toDomain()
    }
}
