//
//  RewardSaveDTO.swift
//  DNetwork
//
//  Created by 문종식 on 6/4/25.
//

public struct RewardSaveDTO: Encodable {
    public var userKey: String
    public let year: Int
    public let month: Int
    public let backgroundId: Int
    public let effectId: Int
    public let decorationId: Int
    public let byeoltongCaseId: Int
    public let bgmId: Int
    
    public init(userKey: String, year: Int, month: Int, backgroundId: Int, effectId: Int, decorationId: Int, byeoltongCaseId: Int, bgmId: Int) {
        self.userKey = userKey
        self.year = year
        self.month = month
        self.backgroundId = backgroundId
        self.effectId = effectId
        self.decorationId = decorationId
        self.byeoltongCaseId = byeoltongCaseId
        self.bgmId = bgmId
    }
}
