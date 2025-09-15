//
//  AppVersionAPI.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

public struct AppVersionAPI {
    private let request = NetworkRequest()
    
    public init() { }
    
    /// 앱 버전 정보 요청
    public func getAppVersion() async throws -> AppVersionResponse {
        let result: ResponseWrapper<AppVersionResponse> = try await request.get(
            path: .appVersion,
            additionalPaths: ["iOS"]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
}
