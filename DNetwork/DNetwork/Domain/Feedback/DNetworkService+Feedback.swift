//
//  DNetworkService+Feedback.swift
//  DNetwork
//
//  Created by 문종식 on 5/18/25.
//

public extension DNetworkService {
    struct DFeedback {
        let request: DNetworkRequest
        let userKey: String
        
        public init() {
            self.request = DNetworkRequest()
            self.userKey = DNetworkService.userKey
        }
        
        public func receiveFeedbackCard() async throws -> FeedbackCardDTO? {
            let response: DResponse<FeedbackCardDTO> = try await self.request.get(
                path: .feedback,
                addtionalPath: ["content", userKey]
            )
            return response.responseData
        }
        
        public func fetchFeedbackInfo() async throws -> FeedbackInfoDTO? {
            let response: DResponse<FeedbackInfoDTO> = try await self.request.get(
                path: .feedback,
                addtionalPath: [userKey]
            )
            return response.responseData
        }
    }
}
