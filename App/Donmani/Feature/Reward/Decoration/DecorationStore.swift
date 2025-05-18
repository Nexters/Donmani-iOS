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
        init() {
            
        }
    }
    
    @ObservableState
    struct State {
        var isPresentingGuideBottomSheet = false
        
        init(context: Context) {
            
        }
    }
    
    enum Action {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        
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
            default:
                break
            }
            return .none
        }
    }
}
