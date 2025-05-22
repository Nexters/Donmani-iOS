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
    
    func image() -> DImage {
        var rewardResource: RewardResourceMappable!
        switch category {
        case .background:
            rewardResource = RewardBackgroundResource(rawValue: id)
        case .effect:
            rewardResource = RewardEffectResource(rawValue: id)
        case .decoration:
            rewardResource = RewardDecorationResource(rawValue: id)
        case .byeoltong:
            rewardResource = RewardBottleResource(rawValue: id)
        case .sound:
            rewardResource = RewardSoundResource(rawValue: id)
        }
        return rewardResource.image()
    }
}

private protocol RewardResourceMappable {
    func image() -> DImage
}

private enum RewardBackgroundResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardBgDefault:
            imageAsset = .rewardBgDefault
        case .rewardBgPurpleAurora:
            imageAsset = .rewardBgPurpleAurora
        case .rewardBgSkyPathway:
            imageAsset = .rewardBgSkyPathway
        case .rewardBgStarOcean:
            imageAsset = .rewardBgStarOcean
        }
        return DImage(imageAsset)
    }
    
    case rewardBgDefault = 101
    case rewardBgPurpleAurora = 102
    case rewardBgStarOcean = 103
    case rewardBgSkyPathway = 104
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
    
    case rewardBottleDefault = 101
    case rewardBottleBeads = 102
    case rewardBottleFuzzy = 103
}

private enum RewardDecorationResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardEmpty:
            imageAsset = .rewardEmpty
        case .rewardDecorationFloatingBoat:
            imageAsset = .rewardDecorationFloatingBoat
        case .rewardDecorationFuzzyBalloon:
            imageAsset = .rewardDecorationFuzzyBalloon
        case .rewardDecorationMoonPillow:
            imageAsset = .rewardDecorationMoonPillow
        case .rewardDecorationTobyShip:
            imageAsset = .rewardDecorationTobyShip
        case .rewardDecorationSpaceVacance:
            imageAsset = .rewardDecorationSpaceVacance
        }
        return DImage(imageAsset)
    }
    
    case rewardEmpty = 100
    case rewardDecorationSpaceVacance = 101
    case rewardDecorationTobyShip = 102
    case rewardDecorationFuzzyBalloon = 103
    case rewardDecorationMoonPillow = 104
    case rewardDecorationFloatingBoat = 105
}

private enum RewardEffectResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardEmpty:
            imageAsset = .rewardEmpty
        case .rewardEffectFloatingBubble:
            imageAsset = .rewardEffectFloatingBubble
        case .rewardEffectHeartRipple:
            imageAsset = .rewardEffectHeartRipple
        case .rewardEffectWishingMeteor:
            imageAsset = .rewardEffectWishingMeteor
        }
        return DImage(imageAsset)
    }
    
    case rewardEmpty = 100
    case rewardEffectHeartRipple = 101
    case rewardEffectFloatingBubble = 102
    case rewardEffectWishingMeteor = 103
}

private enum RewardSoundResource: Int, RewardResourceMappable {
    func image() -> DImage {
        var imageAsset: DImageAsset!
        switch self {
        case .rewardEmpty:
            imageAsset = .rewardEmpty
        case .rewardSoundStardropDay:
            imageAsset = .rewardSoundStardropDay
        case .rewardSoundWhisperingStarlight:
            imageAsset = .rewardSoundWhisperingStarlight
        }
        return DImage(imageAsset)
    }
    
    case rewardEmpty = 100
    case rewardSoundStardropDay = 101
    case rewardSoundWhisperingStarlight = 102
}
