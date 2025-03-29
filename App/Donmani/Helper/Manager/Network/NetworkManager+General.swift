//
//  NetworkManager+General.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//


import DNetwork

extension NetworkManager {
    struct Version {
        let service: DNetworkService
        
        init (
            service: DNetworkService
        ) {
            self.service = service
        }
        
        func requsetAppVersionFromAppStore() async throws -> String {
            let result: AppInfoDTO = try await self.service.requestAppVersion()
            return result.results[0].version ?? "0.0"
        }
        
        func requsetAppVersionFromServer() async throws -> VersionDTO {
            let responseData: VersionDTO = try await self.service.requestGET(
                path: .api,
                addtionalPath: ["v1", "appVersion", "iOS"]
            )
            return responseData
        }
    }
}
