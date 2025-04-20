//
//  DNetworkService.swift
//  Donmani
//
//  Created by 문종식 on 4/15/25.
//

public struct DNetworkService {
    static var userKey: String = ""
    public static func setUserKey(_ key: String) {
        Self.userKey = key
    }
    public static func getUserKey(_ key: String) -> String {
        return Self.userKey
    }
}
