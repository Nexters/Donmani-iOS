//
//  AppInfoDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

public struct AppInfoDTO: Decodable {
    public let results: [AppVersionDTO]
}

public struct AppVersionDTO: Decodable {
    public let version: String?
}
