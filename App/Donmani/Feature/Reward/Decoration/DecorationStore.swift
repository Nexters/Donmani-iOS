//
//  DecorationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import DesignSystem
import Lottie
import SwiftUI

@Reducer
struct DecorationStore {
    
    struct Context {
        let decorationItem: [RewardItemCategory : [Reward]]
        var currentDecorationItem: [RewardItemCategory : Reward]
        let selectedCategory: RewardItemCategory
        
        init(
            decorationItem: [RewardItemCategory : [Reward]],
            currentDecorationItem: [Reward],
            selectedCategory: RewardItemCategory
        ) {
            self.decorationItem = decorationItem
            self.currentDecorationItem = [:]
            for reward in currentDecorationItem {
                self.currentDecorationItem[reward.category] = reward
            }
            self.selectedCategory = selectedCategory
        }
    }
    
    @ObservableState
    struct State {
        var isPresentingGuideBottomSheet = false
        var isPresentingFinalBottomSheet = false
        var selectedRewardItemCategory: RewardItemCategory = .background
    
        var decorationItem: [RewardItemCategory : [Reward]]
        var selectedDecorationItem: [RewardItemCategory : Reward]
        var previousDecorationItem: [RewardItemCategory : Reward]
        var backgroundShape: DImageAsset
        
        var disabledSaveButton = true
        
        var itemList: [Reward] {
            decorationItem[selectedRewardItemCategory, default: []]
        }
        
        var monthlyRecords: [Record]
        
        var isSoundOn: Bool = false
        let lottieAnimation = LottieAnimation.named(
            "lottie_equalizer",
            bundle: .designSystem
        )
        
        let lottieFinalAnimation = LottieAnimation.named(
            "lottie_reward_final_bottom_sheet",
            bundle: .designSystem
        )
        let confettiLottieAnimation = LottieAnimation.named(
            "lottie_confetti",
            bundle: .designSystem
        )
        
        var byeoltongImageType : DImageAsset {
            let id = selectedDecorationItem[.byeoltong]?.id ?? 4
            switch id {
            case 24:
                return .rewardBottleBeads
            case 25:
                return .rewardBottleFuzzy
            default:
                return .rewardBottleDefault
            }
        }
        
        var byeoltongShapeType : DImageAsset = .rewardBottleDefaultShape
        
        init(context: Context) {
            self.decorationItem = context.decorationItem
            self.selectedDecorationItem = context.currentDecorationItem
            self.previousDecorationItem = context.currentDecorationItem
            self.selectedRewardItemCategory = context.selectedCategory
            
            backgroundShape = .rewardBottleDefault
            byeoltongShapeType = {
                switch (context.currentDecorationItem[.byeoltong]?.id ?? 4) {
                case 24:
                    return .rewardBottleBeadsShape
                case 25:
                    return .rewardBottleFuzzyShape
                default:
                    return .rewardBottleDefaultShape
                }
            }()
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            let monthlyRecords = DataStorage.getRecord(yearMonth: "\(today[0])-\(today[1])") ?? []
            self.monthlyRecords = monthlyRecords
            self.isPresentingGuideBottomSheet = HistoryStateManager.shared.getIsFirstDecorationEnter()
        }
    }
    
    enum Action: BindableAction {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        case touchFinalBottomSheetButton
        
        case touchRewardItemCategoryButton(RewardItemCategory)
        case touchRewardItem(RewardItemCategory, Reward)
        case touchEqualizerButton
        
        case touchBackButton
        case touchSaveButton
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case pop(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                GA.View.init(event: .customize).send(parameters: [
                    .reward_배경: state.previousDecorationItem[.background]?.name ?? "",
                    .reward_효과: state.previousDecorationItem[.effect]?.name ?? "",
                    .reward_장식: state.previousDecorationItem[.decoration]?.name ?? "",
                    .reward_별통이: state.previousDecorationItem[.byeoltong]?.name ?? "",
                    .reward_효과음: state.previousDecorationItem[.sound]?.name ?? "",
                ])
                if HistoryStateManager.shared.getIsFirstDecorationEnter() {
                    HistoryStateManager.shared.setIsFirstDecorationEnter()
                    state.isPresentingGuideBottomSheet = !state.isPresentingGuideBottomSheet
                    if !state.isPresentingGuideBottomSheet {
                        UINavigationController.isBlockSwipe = false
                    }
                }
                var count = 0
                for (_, value) in state.decorationItem {
                    count += value.count
                }
                if (count >= 19) {
                    if !HistoryStateManager.shared.getIsShownFullRewardBottmeSheet() {
                        HistoryStateManager.shared.setIsShownFullRewardBottmeSheet()
                        state.isPresentingFinalBottomSheet = !state.isPresentingFinalBottomSheet
                    }
                }
                
            case .touchGuideBottomSheetButton:
                return .run { send in
                    await send(.toggleGuideBottomSheet)
                }
                
            case .touchFinalBottomSheetButton:
                state.isPresentingFinalBottomSheet = false
                UINavigationController.isBlockSwipe = false
                
            case .touchRewardItemCategoryButton(let category):
                state.selectedRewardItemCategory = category
                
            case .touchRewardItem(let category, let item):
                guard let previousItem = state.selectedDecorationItem[category] else {
                    return .none
                }
                if (previousItem.id == item.id) {
                    return .none
                }
                state.selectedDecorationItem[category] = item
                if (category == .sound) {
                    if (item.id > 5) {
                        let fileName = RewardResourceMapper(id: item.id, category: .sound).resource()
                        state.isSoundOn = true
                        SoundManager.shared.play(fileName: fileName)
                    } else {
                        state.isSoundOn = false
                        SoundManager.shared.stop()
                    }
                }
                if (category == .byeoltong) {
                    state.byeoltongShapeType = {
                        switch item.id {
                        case 24:
                            return .rewardBottleBeadsShape
                        case 25:
                            return .rewardBottleFuzzyShape
                        default:
                            return .rewardBottleDefaultShape
                        }
                    }()
                }
                let diffCount = state.previousDecorationItem.compactMap { (key, item) in
                    (state.selectedDecorationItem[key]?.id ?? 0) == (item.id) ? nil : 0
                }.count
                state.disabledSaveButton = (diffCount == 0)
                
            case .touchEqualizerButton:
                guard let sound = state.selectedDecorationItem[.sound] else {
                    return .none
                }
                if state.isSoundOn {
                    state.isSoundOn = false
                    SoundManager.shared.stop()
                } else {
                    if (sound.id > 100) {
                        if let fileName = sound.soundUrl {
                            state.isSoundOn = true
                            SoundManager.shared.play(fileName: fileName)
                        }
                    }
                }
            
            case .touchBackButton:
                if SoundManager.isSoundOn {
                    let resource = DataStorage.getSoundFileName()
                    if resource.isNotEmpty {
                        SoundManager.shared.play(fileName: resource)
                    }
                }
                return .run { send in
                    await send(.delegate(.pop(false)))
                }
                
            case .touchSaveButton:
                GA.Click(event: .customizeSubmitButton).send(parameters: [
                    .reward_배경: state.selectedDecorationItem[.background]?.name ?? "",
                    .reward_효과: state.selectedDecorationItem[.effect]?.name ?? "",
                    .reward_장식: state.selectedDecorationItem[.decoration]?.name ?? "",
                    .reward_별통이: state.selectedDecorationItem[.byeoltong]?.name ?? "",
                    .reward_효과음: state.selectedDecorationItem[.sound]?.name ?? "",
                ])
                let item = state.selectedDecorationItem
                DataStorage.setDecorationItem(item)
                let soundItemId = state.selectedDecorationItem[.sound]?.id ?? 5
                let resource = RewardResourceMapper(id: soundItemId, category: .sound).resource()
                DataStorage.setSoundFileName(resource)
                if SoundManager.isSoundOn {
                    if resource.isNotEmpty {
                        SoundManager.shared.play(fileName: resource)
                    }
                }
                return .run { send in
                    let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                    let year = Int(today[0]) ?? 2025
                    let month = Int(today[1]) ?? 6
                    let dto = NetworkRequestDTOMapper.mapper(year: year, month: month, item: item)
                    try await NetworkService.DReward().saveDecoration(dto: dto)
                    await send(.delegate(.pop(true)))
                }

            default:
                break
            }

            return .none
        }
    }
}
