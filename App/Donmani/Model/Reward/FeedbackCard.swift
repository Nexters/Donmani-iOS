//
//  FeedbackCard.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

struct FeedbackCard {
    let category: RecordCategory?
    let title: String
    let content: String
    let prefix: String

    static let previewData: FeedbackCard = {
        let category = RecordCategory(GoodCategory.happiness)
        let title = "최대 12자 타이틀"
        let content = "나만 아는 행복이었던 것 같아,\n그래서 더 소중해 💛"
        return FeedbackCard(category: category, title: title, content: content, prefix: "오늘은")
    }()
}
