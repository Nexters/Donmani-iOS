//
//  AppVersionRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

final actor AppVersionRepository {
    private let dataSource = AppVersionAPI()
    
    /// 앱 버전 정보 요청
    func getAppVersion() async throws -> Version {
        let response = try await dataSource.getAppVersion()
        return response.toDomain()
    }
}
