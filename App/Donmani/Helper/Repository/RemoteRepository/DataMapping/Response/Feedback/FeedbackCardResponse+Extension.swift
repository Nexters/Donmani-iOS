//
//  FeedbackCardResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

extension FeedbackCardResponse {
    func toDomain() -> FeedbackCard {
        let rawValue = self.category.lowercased()
        let category = RecordCategory(rawValue: rawValue)
        return FeedbackCard(
            category: category,
            title: self.title,
            content: self.content,
            prefix: self.flagType ? "오늘은" : "요즘은"
        )
    }
}
