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
            case pushDecoration([Record], [RewardItemCategory: [Reward]], [Reward])
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.recordRepository) var recordRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchDecorationButton:
                GA.Click(event: .settingCustomize).send()
                return .run { send in
                    let day: Day = .today
                    let records = recordRepository.loadRecords(year: day.year, month: day.month)
                    async let decorationItemTask = rewardRepository.getUserRewardItem()
                    async let currentDecorationItemTask = rewardRepository.getMonthlyRewardItem(year: day.year, month: day.month )
                    let (decorationItem, currentDecorationItem) = try await (decorationItemTask, currentDecorationItemTask)
                    await send(.delegate(.pushDecoration(records ?? [], decorationItem, currentDecorationItem)))
                }
                
            case .updateUserName(let userName):
                state.userName = userName
                
            default:
                break
            }
            return .none
        }
    }
}
