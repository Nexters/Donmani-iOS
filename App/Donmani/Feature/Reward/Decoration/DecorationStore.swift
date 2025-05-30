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
        var isPresentingGuideBottomSheet = true //false
        var selectedRewardItemCategory: RewardItemCategory = .background
    
        
        let decorationItem: [RewardItemCategory : [Reward]]
        var selectedDecorationItem: [RewardItemCategory : Reward]
        var backgroundShape: DImageAsset
        
        var itemList: [Reward] {
            decorationItem[selectedRewardItemCategory, default: []]
        }
        
        var isSoundOn: Bool = false
        let lottieAnimation = LottieAnimation.named(
            "lottie_equalizer",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.decorationItem = context.decorationItem
            self.selectedDecorationItem = [
                .background: .init(id: 101, name: "", imageUrl: "", soundUrl: "", category: .background, owned: true),
                .effect: .init(id: 100, name: "", imageUrl: "", soundUrl: "", category: .effect, owned: true),
                .decoration: .init(id: 100, name: "", imageUrl: "", soundUrl: "", category: .decoration, owned: true),
                .byeoltong: .init(id: 101, name: "", imageUrl: "", soundUrl: "", category: .byeoltong, owned: true),
                .sound: .init(id: 100, name: "", imageUrl: "", soundUrl: "", category: .sound, owned: true),
            ]
            backgroundShape = .rewardBottleDefault
        }
    }
    
    enum Action {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        case touchRewardItemCategoryButton(RewardItemCategory)
        case touchRewardItem(RewardItemCategory, Reward)
        case touchEqualizerButton
        
        case delegate(Delegate)
        enum Delegate {
            case popToRoot
        }
    }
    
    var body: some ReducerOf<Self> {
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
