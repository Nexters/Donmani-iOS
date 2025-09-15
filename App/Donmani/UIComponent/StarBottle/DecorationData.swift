//
//  DecorationData.swift
//  Donmani
//
//  Created by 문종식 on 9/14/25.
//

import Foundation

struct DecorationData {
    let backgroundRewardData: Data?
    let effectRewardData: Data?
    let decorationRewardName: String?
    let decorationRewardId: Int?
    let bottleRewardId: Int?
    let bottleShape: BottleShape
    
    init(backgroundRewardData: Data?, effectRewardData: Data?, decorationRewardName: String?, decorationRewardId: Int?, bottleRewardId: Int?, bottleShape: BottleShape) {
        self.backgroundRewardData = backgroundRewardData
        self.effectRewardData = effectRewardData
        self.decorationRewardName = decorationRewardName
        self.decorationRewardId = decorationRewardId
        self.bottleRewardId = bottleRewardId
        self.bottleShape = bottleShape
    }
}
