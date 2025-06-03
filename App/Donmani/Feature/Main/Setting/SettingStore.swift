//
//  SettingStore.swift
//  Donmani
//
//  Created by 문종식 on 6/2/25.
//

import ComposableArchitecture
import DesignSystem
import DNetwork

@Reducer
struct SettingStore {
    
    @ObservableState
    struct State {
        
    }
    
    enum Action {
        case touchDecorationButton
        case toggleBackgroundSound
        
        case delegate(Delegate)
        enum Delegate {
            case pushDecoration([RewardItemCategory: [Reward]])
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .touchDecorationButton:
                return .run { send in
                    let dto = try await NetworkService.DReward().reqeustRewardItem()
                    let decorationItem = NetworkDTOMapper.mapper(dto: dto)
                    await send(.delegate(.pushDecoration(decorationItem)))
                }
            case .toggleBackgroundSound:
                return .none
                
            default:
                break
            }
            return .none
        }
    }
}
