//
//  Reward.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

struct RewardItem {
    let id: Int
    let name: String
    let imageUrl: String?
    let soundUrl: String?
    let category: RewardItemCategory
    let owned: Bool
    
    static let previewData: [RewardItem] = [
        RewardItem(id: 101, name: "보랏빛 오로라 배경", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        RewardItem(id: 102, name: "몽글몽글 열기구", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        RewardItem(id: 103, name: "둥둥배", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false)
    ]
}
