//
//  Reward.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

struct Reward {
    let id: Int
    let name: String
    let imageUrl: String?
    let soundUrl: String?
    let category: RewardItemCategory
    let owned: Bool
    
    static let previewData: [Reward] = [
        Reward(id: 102, name: "보랏빛 오로라 배경", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        Reward(id: 102, name: "몽글몽글 열기구", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false),
        Reward(id: 104, name: "둥둥배", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false)
    ]
    
    static let previewAllData: [Reward] = [
        Reward(id: 101, name: "기본 배경", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        Reward(id: 102, name: "보랏빛 오로라 배경", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        Reward(id: 103, name: "별이 흐르는 바다 배경", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        Reward(id: 104, name: "별이 흐르는 바다 배경", imageUrl: nil,
                   soundUrl: nil, category: .background, owned: false),
        
        Reward(id: 100, name: "없음", imageUrl: nil,
               soundUrl: nil, category: .effect, owned: false),
        Reward(id: 101, name: "하트잔잔", imageUrl: nil,
               soundUrl: nil, category: .effect, owned: false),
        Reward(id: 102, name: "둥실둥실 방울", imageUrl: nil,
               soundUrl: nil, category: .effect, owned: false),
        Reward(id: 103, name: "소원의 유성", imageUrl: nil,
               soundUrl: nil, category: .effect, owned: false),
        
        Reward(id: 100, name: "없음", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false),
        Reward(id: 102, name: "토비호", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false),
        Reward(id: 103, name: "몽글몽글 열기구", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false),
        Reward(id: 104, name: "둥둥배", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false),
        Reward(id: 105, name: "달베개", imageUrl: nil,
               soundUrl: nil, category: .decoration, owned: false),
        
        Reward(id: 101, name: "기본 별통이", imageUrl: nil,
               soundUrl: nil, category: .byeoltong, owned: false),
        Reward(id: 102, name: "구슬 별통이", imageUrl: nil,
               soundUrl: nil, category: .byeoltong, owned: false),
        Reward(id: 103, name: "몽글 별통이", imageUrl: nil,
               soundUrl: nil, category: .byeoltong, owned: false),
        
        Reward(id: 100, name: "없음", imageUrl: nil,
               soundUrl: nil, category: .sound, owned: false),
        Reward(id: 101, name: "별사탕의 하루", imageUrl: nil,
               soundUrl: nil, category: .sound, owned: false),
        Reward(id: 102, name: "속삭이는 별빛", imageUrl: nil,
               soundUrl: nil, category: .sound, owned: false),
    ]
}
