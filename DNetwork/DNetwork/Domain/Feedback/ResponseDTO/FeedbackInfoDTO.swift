//
//  FeedbackInfoDTO.swift
//  DNetwork
//
//  Created by 문종식 on 5/18/25.
//

public struct FeedbackInfoDTO: Decodable {
    public let isNotOpened: Bool
    public let isFirstOpened: Bool
    public let totalCount: Int
}
