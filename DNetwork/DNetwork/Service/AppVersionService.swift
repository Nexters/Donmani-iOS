//
//  AppVersionService.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

struct AppVersionService {
    let request: NetworkRequest
    
    init(request: NetworkRequest) {
        self.request = request
    }
    
    /// 앱 버전 정보 요청
    func getAppVersion() async throws -> AppVersionResponse {
        let result: DResponse<AppVersionResponse> = try await request.get(
            path: .appVersion
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
}
