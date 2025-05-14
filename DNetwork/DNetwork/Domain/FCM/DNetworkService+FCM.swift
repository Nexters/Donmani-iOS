//
//  DNetworkService+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

public extension DNetworkService {
    struct FCM {
        let request: DNetworkRequest
        let userKey: String
        
        public init() {
            self.request = DNetworkRequest()
            self.userKey = DNetworkService.userKey
        }
        
        public func register(token: String) async throws -> String {
            let response: String = try await request.post(
                urlString: DURL.api.urlString,
                addtionalPath: [userKey, "token"],
                bodyData: token
            )
            return response
        }
    }
}
