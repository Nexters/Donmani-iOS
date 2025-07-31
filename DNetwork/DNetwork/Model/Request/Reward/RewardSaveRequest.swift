//
//  RewardSaveRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct RewardSaveRequest: Encodable {
    private let userKey: String
    private let year: Int
    private let month: Int
    private let backgroundId: Int
    private let effectId: Int
    private let decorationId: Int
    private let byeoltongCaseId: Int
    
    public init(
        userKey: String,
        year: Int,
        month: Int,
        backgroundId: Int,
        effectId: Int,
        decorationId: Int,
        byeoltongCaseId: Int
    ) {
        self.userKey = userKey
        self.year = year
        self.month = month
        self.backgroundId = backgroundId
        self.effectId = effectId
        self.decorationId = decorationId
        self.byeoltongCaseId = byeoltongCaseId
    }
}
