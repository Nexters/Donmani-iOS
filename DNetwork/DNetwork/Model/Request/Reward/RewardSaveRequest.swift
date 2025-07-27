//
//  RewardSaveRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

struct RewardSaveRequest: Encodable {
    let userKey: String
    let year: Int
    let month: Int
    let backgroundId: Int
    let effectId: Int
    let decorationId: Int
    let byeoltongCaseId: Int
}
