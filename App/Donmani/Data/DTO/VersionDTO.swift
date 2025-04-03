//
//  VersionDTO.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

struct VersionDTO: Codable {
    let statusCode: Int
    let responseMessage: String
    let responseData: [String: String]
//    {
//      "statusCode": 1073741824,
//      "responseMessage": "string",
//      "responseData": {
//        "platformType": "Android",
//        "latestVersion": "string",
//        "forcedUpdateYn": "string"
//      }
//    }
}
