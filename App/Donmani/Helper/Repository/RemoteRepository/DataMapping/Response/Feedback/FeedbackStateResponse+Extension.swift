//
//  FeedbackStateResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

extension FeedbackStateResponse {
    func toDomain() -> FeedbackInfo {
        FeedbackInfo(
            isNotOpened: self.isNotOpened,
            isFirstOpened: self.isFirstOpen,
            totalCount: self.totalCount
        )
    }
}
