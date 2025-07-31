//
//  FeedbackState.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct FeedbackStateResponse: Decodable {
    public let isNotOpened: Bool
    public let isFirstOpen: Bool
    public let totalCount: Int
}
