//
//  Reward.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

struct Reward: Hashable {
    let id: Int
    let name: String
    let imageUrl: String?
    let jsonUrl: String?
    let soundUrl: String?
    let category: RewardItemCategory
    let owned: Bool
    let newAcquiredFlag: Bool
    
    var key: String {
        "\(id)-\(category)"
    }
    
    static let previewData: [Reward] = [
        Reward(id: 11, name: "하늘위 산책로 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .background,
               owned: false, newAcquiredFlag: false),
        Reward(id: 24, name: "구슬 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .byeoltong,
               owned: false, newAcquiredFlag: false),
        Reward(id: 29, name: "속삭이는 별빛", imageUrl: nil,
               jsonUrl: nil, soundUrl: "reward_sound_whispering_starlight", category: .sound,
               owned: false, newAcquiredFlag: false),
        Reward(id: 13, name: "소원의 유성", imageUrl: "lottie_reward_effect_wishing_meteor",
               jsonUrl: nil, soundUrl: nil, category: .effect,
               owned: false, newAcquiredFlag: false),
        Reward(id: 19, name: "달베개", imageUrl: "lottie_reward_decoration_moon_pillow",
               jsonUrl: nil, soundUrl: nil, category: .decoration,
               owned: false, newAcquiredFlag: false),
    ]
    
    static let previewAllData: [Reward] = [
        Reward(id: 1, name: "기본 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .background,
               owned: false, newAcquiredFlag: false),
        Reward(id: 10, name: "보랏빛 오로라 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .background,
               owned: false, newAcquiredFlag: false),
        Reward(id: 9, name: "별이 흐르는 바다 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .background,
               owned: false, newAcquiredFlag: false),
        Reward(id: 11, name: "하늘위 산책로 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .background,
               owned: false, newAcquiredFlag: false),
        
        Reward(id: 4, name: "기본 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .byeoltong,
               owned: false, newAcquiredFlag: false),
        Reward(id: 24, name: "구슬 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .byeoltong,
               owned: false, newAcquiredFlag: false),
        Reward(id: 25, name: "몽글 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, category: .byeoltong,
               owned: false, newAcquiredFlag: false),
        
        Reward(id: 28, name: "별사탕의 하루", imageUrl: nil,
               jsonUrl: nil, soundUrl: "reward_sound_stardrop_day", category: .sound,
               owned: false, newAcquiredFlag: false),
        Reward(id: 29, name: "속삭이는 별빛", imageUrl: nil,
               jsonUrl: nil, soundUrl: "reward_sound_whispering_starlight", category: .sound,
               owned: false, newAcquiredFlag: false),
        
        Reward(id: 14, name: "하트잔잔", imageUrl: "lottie_reward_effect_heart_ripple",
               jsonUrl: nil, soundUrl: nil, category: .effect,
               owned: false, newAcquiredFlag: false),
        Reward(id: 12, name: "둥실둥실 방울", imageUrl: "lottie_reward_effect_floating_bubble",
               jsonUrl: nil, soundUrl: nil, category: .effect,
               owned: false, newAcquiredFlag: false),
        Reward(id: 13, name: "소원의 유성", imageUrl: "lottie_reward_effect_wishing_meteor",
               jsonUrl: nil, soundUrl: nil, category: .effect,
               owned: false, newAcquiredFlag: false),
        
        Reward(id: 22, name: "토비호", imageUrl: "lottie_reward_decoration_toby_ship",
               jsonUrl: nil, soundUrl: nil, category: .decoration,
               owned: false, newAcquiredFlag: false),
        Reward(id: 21, name: "몽글몽글 열기구", imageUrl: "lottie_reward_decoration_fuzzy_balloon",
               jsonUrl: nil, soundUrl: nil, category: .decoration,
               owned: false, newAcquiredFlag: false),
        Reward(id: 19, name: "달베개", imageUrl: "lottie_reward_decoration_moon_pillow",
               jsonUrl: nil, soundUrl: nil, category: .decoration,
               owned: false, newAcquiredFlag: false),
        Reward(id: 20, name: "둥둥배", imageUrl: "lottie_reward_decoration_floating_boat",
               jsonUrl: nil, soundUrl: nil, category: .decoration,
               owned: false, newAcquiredFlag: false),
    ]
}
