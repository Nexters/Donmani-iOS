//
//  MonthlyStarBottleStore.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import ComposableArchitecture
import DesignSystem

@Reducer
struct MonthlyStarBottleStore {
    struct Context {
        let day: Day
        let records: [Record]
        let decorationData: DecorationData
        
        init(day: Day, records: [Record], decorationData: DecorationData) {
            self.day = day
            self.records = records
            self.decorationData = decorationData
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let day: Day
        let records: [Record]
        let decorationData: DecorationData
        var starBottleAction: StarBottleAction = .none
        
        init(context: Context) {
            self.day = context.day
            self.records = context.records
            self.decorationData = context.decorationData
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didTapStarBottle
        
        case delegate(Delegate)
        enum Delegate {
            case pushRecordListView(Day, [Record])
        }
    }
    
    @Dependency(\.fileRepository) var fileRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .didTapStarBottle:
                let day = state.day
                let records = state.records
                return .run { send in
                    await send(.delegate(.pushRecordListView(day, records)))
                }
            
            default:
                break
            }
            return .none
        }
    }
}
