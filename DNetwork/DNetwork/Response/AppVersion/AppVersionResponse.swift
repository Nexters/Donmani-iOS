//
//  AppVersionResponse.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

public struct AppVersionResponse: Decodable {
    public let platformType: String
    public let latestVersion: String
    public let forcedUpdateYn: String
}
