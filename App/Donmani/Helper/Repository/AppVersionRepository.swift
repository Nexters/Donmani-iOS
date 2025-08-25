//
//  AppVersionRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork
import ComposableArchitecture

protocol AppVersionRepository {
    func getAppVersion() async throws -> Version
}

struct DefaultAppVersionRepository: AppVersionRepository {
    private let dataSource = AppVersionAPI()
    
    /// 앱 버전 정보 요청
    func getAppVersion() async throws -> Version {
        let response = try await dataSource.getAppVersion()
        return response.toDomain()
    }
}

extension DependencyValues {
    private enum AppVersionRepositoryKey: DependencyKey {
        static let liveValue: AppVersionRepository = DefaultAppVersionRepository()
    }
    
    var appVersionRepository: AppVersionRepository {
        get { self[AppVersionRepositoryKey.self] }
        set { self[AppVersionRepositoryKey.self] = newValue }
    }
}
