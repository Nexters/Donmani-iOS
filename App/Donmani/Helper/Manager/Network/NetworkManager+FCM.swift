//
//  NetworkManager+User.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    struct NMFcm {
        let service: DNetworkRequest
        
        init (
            service: DNetworkRequest
        ) {
            self.service = service
        }
        
        func registerToken(token: String) async throws -> String {
            let responseData: String? = try await self.service.requestPOST(
                path: .api,
                addtionalPath: ["v1", NetworkManager.userKey, "token"],
                bodyData: token
            )
            guard let token = responseData else {
                throw NetworkError.noData
            }
            return token
        }
    }
}
