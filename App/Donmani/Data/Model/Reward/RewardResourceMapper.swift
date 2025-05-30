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
    
    case rewardBgDefault = 101
    case rewardBgPurpleAurora = 102
    case rewardBgStarOcean = 103
    case rewardBgSkyPathway = 104
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
    
    case rewardBgDefault = 101
    case rewardBgPurpleAurora = 102
    case rewardBgStarOcean = 103
    case rewardBgSkyPathway = 104
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
    
    case rewardBottleDefault = 101
    case rewardBottleBeads = 102
    case rewardBottleFuzzy = 103
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
            imageAsset = .rewardIconEmpty
        case .rewardSoundStardropDay:
            imageAsset = .rewardIconSoundStardropDay
        case .rewardSoundWhisperingStarlight:
            imageAsset = .rewardIconSoundWhisperingStarlight
        }
        return DImage(imageAsset)
    }
    
    case rewardEmpty = 100
    case rewardSoundStardropDay = 101
    case rewardSoundWhisperingStarlight = 102
}
