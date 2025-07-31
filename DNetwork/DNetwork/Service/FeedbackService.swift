//
//  FeedbackService.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct FeedbackService {
    private let request: NetworkRequest
    
    public init(request: NetworkRequest) {
        self.request = request
    }
    
    /// 피드백 상태(미확인 리워드, 첫 오픈 여부, 리워드 개수)
    public func getFeedbackState(userKey: String) async throws -> FeedbackStateResponse {
        let result: DResponse<FeedbackStateResponse> = try await request.get(
            path: .feedback,
            addtionalPaths: [userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 피드백 카드 정보
    public func getFeedbackCard(userKey: String) async throws -> FeedbackCardResponse {
        let result: DResponse<FeedbackCardResponse> = try await request.get(
            path: .feedback,
            addtionalPaths: ["content", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
}
