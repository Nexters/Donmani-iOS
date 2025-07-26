//
//  AppVersionService.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

struct AppVersionService {
    func getAppVersion() async throws -> AppVersionResponse {
        try await DNetworkRequest().get(urlString: <#T##String#>, parameters: <#T##[String : Any]?#>)
    }
}
