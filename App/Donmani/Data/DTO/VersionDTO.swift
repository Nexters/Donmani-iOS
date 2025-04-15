//
//  VersionDTO.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

struct VersionDTO: Codable {
    let platformType: String
    let latestVersion: String
    let forcedUpdateYn: String
}
