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
    
    struct Context {
        let userName: String
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        var userName: String
    
        init(context: Context) {
            self.userName = context.userName
        }
    }

    // MARK: - Action
    enum Action: BindableAction {
        case touchDecorationButton
        case updateUserName(String)
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case pushDecoration([RewardItemCategory: [Reward]], [Reward])
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.rewardRepository) var rewardRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchDecorationButton:
                GA.Click(event: .settingCustomize).send()
                return .run { send in
                    let decorationItem = try await self.rewardRepository.getUserRewardItem()
                    let currentDecorationItem = try await self.rewardRepository.getMonthlyRewardItem(
                        year: Day.today.year,
                        month: Day.today.month
                    )
                    await send(.delegate(.pushDecoration(decorationItem, currentDecorationItem)))
                }
                
            case .updateUserName(let userName):
                state.userName = userName
                
            default:
                return .none
            }
        }
    }
}
