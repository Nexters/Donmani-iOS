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
        
        init(decorationItem: [RewardItemCategory : [Reward]]) {
            self.decorationItem = decorationItem
        }
    }
    
    @ObservableState
    struct State {
        var isPresentingGuideBottomSheet = false // true
        var selectedRewardItemCategory: RewardItemCategory = .background
    
        
        let decorationItem: [RewardItemCategory : [Reward]]
        var selectedDecorationItem: [RewardItemCategory : Reward]
        var backgroundShape: DImageAsset
        
        var itemList: [Reward] {
            decorationItem[selectedRewardItemCategory, default: []]
        }
        
        var monthlyRecords: [Record]
        
        var isSoundOn: Bool = false
        let lottieAnimation = LottieAnimation.named(
            "lottie_equalizer",
            bundle: .designSystem
        )
        
        var byeoltongImageType : DImageAsset {
            let id = selectedDecorationItem[.byeoltong]?.id ?? 101
//            print(id)
            switch id {
            case 102:
                return .rewardBottleBeads
            case 103:
                return .rewardBottleFuzzy
            default:
                return .rewardBottleDefault
            }
        }
        
        var byeoltongShapeType : DImageAsset = .rewardBottleDefaultShape
        
        init(context: Context) {
            self.decorationItem = context.decorationItem
            self.selectedDecorationItem = [:]
            
            backgroundShape = .rewardBottleDefault
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            let monthlyRecords = DataStorage.getRecord(yearMonth: "\(today[0])-\(today[1])") ?? []
            self.monthlyRecords = monthlyRecords
        }
    }
    
    enum Action: BindableAction {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        case touchRewardItemCategoryButton(RewardItemCategory)
        case touchRewardItem(RewardItemCategory, Reward)
        case touchEqualizerButton
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case popToRoot
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                if HistoryStateManager.shared.getIsFirstDecorationEnter() {
                    HistoryStateManager.shared.setIsFirstDecorationEnter()
                    state.isPresentingGuideBottomSheet = !state.isPresentingGuideBottomSheet
                    if !state.isPresentingGuideBottomSheet {
                        UINavigationController.isBlockSwipe = false
                    }
                }
                
            case .touchGuideBottomSheetButton:
                return .run { send in
                    await send(.toggleGuideBottomSheet)
                }
                
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
                    if (item.id > 100) {
                        if let fileName = item.soundUrl {
                            state.isSoundOn = true
                            SoundManager.shared.play(fileName: fileName)
                        }
                    } else {
                        state.isSoundOn = false
                        SoundManager.shared.stop()
                    }
                }
                if (category == .byeoltong) {
                    state.byeoltongShapeType = {
                        switch item.id {
                        case 102:
                            return .rewardBottleBeadsShape
                        case 103:
                            return .rewardBottleFuzzyShape
                        default:
                            return .rewardBottleDefaultShape
                        }
                    }()
                }
                
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
            default:
                break
            }
            return .none
        }
    }
}
