//
//  DNetworkService+General.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

public extension DNetworkService {
    struct Version {
        let request: DNetworkRequest
        
        public init() {
            self.request = DNetworkRequest()
        }
        
        public func fetchAppVersionFromAppStore() async throws -> String {
            let result: AppInfoDTO = try await self.request.get(urlString: DURL.appInfo.urlString)
            return result.results[0].version ?? "0.0"
        }
        
        public func fetchAppVersionFromServer() async throws -> VersionDTO {
            let response: DResponse<VersionDTO> = try await self.request.get(
                path: .appVersion,
                additionalPath: ["iOS"]
            )
            guard let data = response.responseData else {
                throw NetworkError.noData
            }
            return data
        }
    }
}
