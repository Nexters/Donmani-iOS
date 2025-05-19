//
//  DecorationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import UIKit

@Reducer
struct DecorationStore {
    
    struct Context {
        let decorationItem: [RewardItemCategory : [RewardItem]]
        
        init(decorationItem: [RewardItemCategory : [RewardItem]]) {
            self.decorationItem = decorationItem
        }
    }
    
    @ObservableState
    struct State {
        var isPresentingGuideBottomSheet = false
        var selectedRewardItemCategory: RewardItemCategory = .background
        let decorationItem: [RewardItemCategory : [RewardItem]]
        var itemList: [RewardItem] {
            decorationItem[selectedRewardItemCategory, default: []]
        }
        
        init(context: Context) {
            self.decorationItem = context.decorationItem
        }
    }
    
    enum Action {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        case touchRewardItemCategoryButton(RewardItemCategory)
        
        case delegate(Delegate)
        enum Delegate {
            case popToRoot
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                state.isPresentingGuideBottomSheet = !state.isPresentingGuideBottomSheet
                if !state.isPresentingGuideBottomSheet {
                    UINavigationController.isBlockSwipe = false
                }
                
            case .touchGuideBottomSheetButton:
                return .run { send in
                    await send(.toggleGuideBottomSheet)
                }
                
            case .touchRewardItemCategoryButton(let category):
                state.selectedRewardItemCategory = category
                
            default:
                break
            }
            return .none
        }
    }
}
