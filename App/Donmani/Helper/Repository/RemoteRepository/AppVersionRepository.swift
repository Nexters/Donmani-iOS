//
//  AppVersionRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

final actor AppVersionRepository {
    let service: AppVersionService
    
    init(service: AppVersionService) {
        self.service = service
    }
    
    /// 앱 버전 정보 요청
    func getAppVersion() async throws -> Version {
        let response = try await self.service.getAppVersion()
        return response.toDomain()
    }
}
