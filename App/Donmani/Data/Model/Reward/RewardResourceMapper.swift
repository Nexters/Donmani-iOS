//
//  RewardResourceMapper.swift
//  Donmani
//
//  Created by 문종식 on 5/22/25.
//

import DesignSystem

struct RewardResourceMapper {
    let id: Int
    let category: RewardItemCategory
    
    init(id: Int, category: RewardItemCategory) {
        self.id = id
        self.category = category
    }
    
    func image(isPreview: Bool = false) -> DImage {
        var rewardResource: RewardResourceMappable!
        switch category {
        case .background:
            if isPreview {
                rewardResource = RewardBackgroundPreviewResource(rawValue: id)
            } else {
                rewardResource = RewardBackgroundResource(rawValue: id)
            }
        case .effect:
            rewardResource = RewardEffectResource(rawValue: id)
        case .decoration:
            rewardResource = RewardDecorationResource(rawValue: id)
        case .byeoltong:
            if isPreview {
                rewardResource = RewardIconBottleResource(rawValue: id)
            } else {
                rewardResource = RewardBottleResource(rawValue: id)
            }
        case .sound:
            rewardResource = RewardSoundResource(rawValue: id)
        }
        return rewardResource.image()
    }
}

private protocol RewardResourceMappable {
    func image() -> DImage
    func resourceName() -> String
}

extension RewardResourceMappable {
    func resourceName() -> String {
       return ""
   }
}

private enum RewardBackgroundPreviewResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardBgDefault:
            imageAsset = .rewardPreviewBgDefault
        case .rewardBgPurpleAurora:
            imageAsset = .rewardPreviewBgPurpleAurora
        case .rewardBgSkyPathway:
            imageAsset = .rewardPreviewBgSkyPathway
        case .rewardBgStarOcean:
            imageAsset = .rewardPreviewBgStarOcean
        }
        return DImage(imageAsset)
    }
    
    case rewardBgDefault = 1
    case rewardBgPurpleAurora = 10
    case rewardBgStarOcean = 9
    case rewardBgSkyPathway = 11
}

private enum RewardBackgroundResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardBgDefault:
            imageAsset = .rewardIconBgDefault
        case .rewardBgPurpleAurora:
            imageAsset = .rewardIconBgPurpleAurora
        case .rewardBgSkyPathway:
            imageAsset = .rewardIconBgSkyPathway
        case .rewardBgStarOcean:
            imageAsset = .rewardIconBgStarOcean
        }
        return DImage(imageAsset)
    }
    
    case rewardBgDefault = 1
    case rewardBgPurpleAurora = 10
    case rewardBgStarOcean = 9
    case rewardBgSkyPathway = 11
}

private enum RewardIconBottleResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardBottleBeads:
            imageAsset = .rewardIconBottleBeads
        case .rewardBottleDefault:
            imageAsset = .rewardIconBottleDefault
        case .rewardBottleFuzzy:
            imageAsset = .rewardIconBottleFuzzy
        }
        return DImage(imageAsset)
    }
    
    case rewardBottleDefault = 4
    case rewardBottleBeads = 24
    case rewardBottleFuzzy = 25
}

private enum RewardBottleResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardBottleBeads:
            imageAsset = .rewardBottleBeads
        case .rewardBottleDefault:
            imageAsset = .rewardBottleDefault
        case .rewardBottleFuzzy:
            imageAsset = .rewardBottleFuzzy
        }
        return DImage(imageAsset)
    }
    
    case rewardBottleDefault = 4
    case rewardBottleBeads = 24
    case rewardBottleFuzzy = 25
}

private enum RewardDecorationResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardEmpty:
            imageAsset = .rewardIconEmpty
        case .rewardDecorationFloatingBoat:
            imageAsset = .rewardIconDecorationFloatingBoat
        case .rewardDecorationFuzzyBalloon:
            imageAsset = .rewardIconDecorationFuzzyBalloon
        case .rewardDecorationMoonPillow:
            imageAsset = .rewardIconDecorationMoonPillow
        case .rewardDecorationTobyShip:
            imageAsset = .rewardIconDecorationTobyShip
        case .rewardDecorationSpaceVacance:
            imageAsset = .rewardIconDecorationSpaceVacance
        }
        return DImage(imageAsset)
    }
    
    func resourceName() -> String {
        switch self {
        case .rewardEmpty:
            return ""
        case .rewardDecorationFloatingBoat:
            return "lottie_reward_decoration_floating_boat"
        case .rewardDecorationFuzzyBalloon:
            return "lottie_reward_decoration_fuzzy_balloon"
        case .rewardDecorationMoonPillow:
            return "lottie_reward_decoration_moon_pillow"
        case .rewardDecorationTobyShip:
            return "lottie_reward_decoration_toby_ship"
        case .rewardDecorationSpaceVacance:
            return ""
        }
    }
    
    case rewardEmpty = 3
    case rewardDecorationSpaceVacance = 23
    case rewardDecorationTobyShip = 22
    case rewardDecorationFuzzyBalloon = 21
    case rewardDecorationMoonPillow = 19
    case rewardDecorationFloatingBoat = 20
    
}

private enum RewardEffectResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardEmpty:
            imageAsset = .rewardIconEmpty
        case .rewardEffectFloatingBubble:
            imageAsset = .rewardIconEffectFloatingBubble
        case .rewardEffectHeartRipple:
            imageAsset = .rewardIconEffectHeartRipple
        case .rewardEffectWishingMeteor:
            imageAsset = .rewardIconEffectWishingMeteor
        }
        return DImage(imageAsset)
    }
    
    func resourceName() -> String {
        switch self {
        case .rewardEmpty:
            return ""
        case .rewardEffectFloatingBubble:
            return "lottie_reward_effect_floating_bubble"
        case .rewardEffectHeartRipple:
            return "lottie_reward_effect_heart_ripple"
        case .rewardEffectWishingMeteor:
            return "lottie_reward_effect_wishing_meteor"
        }
    }
    
    case rewardEmpty = 2
    case rewardEffectHeartRipple = 14
    case rewardEffectFloatingBubble = 12
    case rewardEffectWishingMeteor = 13
}

private enum RewardSoundResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardEmpty:
            imageAsset = .rewardIconEmpty
        case .rewardSoundStardropDay:
            imageAsset = .rewardIconSoundStardropDay
        case .rewardSoundWhisperingStarlight:
            imageAsset = .rewardIconSoundWhisperingStarlight
        }
        return DImage(imageAsset)
    }
    
    func resourceName() -> String {
        switch self {
        case .rewardEmpty:
            return ""
        case .rewardSoundStardropDay:
            return "reward_sound_stardrop_day"
        case .rewardSoundWhisperingStarlight:
            return "reward_sound_whispering_starlight"
        }
    }
    
    case rewardEmpty = 5
    case rewardSoundStardropDay = 28
    case rewardSoundWhisperingStarlight = 29
}
