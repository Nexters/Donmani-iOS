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
        let items: [Reward]
        init(day: Day, records: [Record], items: [Reward]) {
            self.day = day
            self.records = records
            self.items = items
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let day: Day
        let records: [Record]
        let decorationItem: [RewardItemCategory: Reward]
        
        init(context: Context) {
            self.day = context.day
            self.records = context.records
            var items: [RewardItemCategory: Reward] = [:]
            for item in context.items {
                items[item.category] = item
            }
            self.decorationItem = items
        }
    }
    
    // MARK: - Action
    enum Action {
        case delegate(Delegate)
        enum Delegate {
            case pushRecordListView(Int, Int)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
}
