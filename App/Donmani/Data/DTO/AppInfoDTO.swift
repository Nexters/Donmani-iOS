//
//  AppInfoDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

struct AppInfoDTO: Equatable, Codable {
    var results: [AppVersionDTO]
}

struct AppVersionDTO: Equatable, Codable {
    var version: String?
}
