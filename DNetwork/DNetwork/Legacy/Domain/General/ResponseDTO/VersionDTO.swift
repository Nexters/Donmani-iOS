//
//  VersionDTO.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

public struct VersionDTO: Decodable {
    public let platformType: String
    public let latestVersion: String
    public let forcedUpdateYn: String
}
