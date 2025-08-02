//
//  AppVersionRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

final actor AppVersionRepository {
    let dataSource: AppVersionAPI
    
    init(dataSource: AppVersionAPI) {
        self.dataSource = dataSource
    }
    
    /// 앱 버전 정보 요청
    func getAppVersion() async throws -> Version {
        let response = try await self.dataSource.getAppVersion()
        return response.toDomain()
    }
}
