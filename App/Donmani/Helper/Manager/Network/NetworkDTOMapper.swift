//
//  NetworkDTOMapper.swift
//  Donmani
//
//  Created by 문종식 on 4/16/25.
//

import DNetwork

struct NetworkDTOMapper {
    static func mapper(dto: VersionDTO) -> Version {
        let isUpdateRequired = dto.forcedUpdateYn == "Y"
        let version = Version(
            latestVersion: dto.latestVersion,
            isUpdateRequired: isUpdateRequired
        )
        return version
    }
    
    static func mapper(dto: AppInfoDTO) -> String {
        let version = dto.results.first?.version ?? "0.0.0"
        return version
    }
}
