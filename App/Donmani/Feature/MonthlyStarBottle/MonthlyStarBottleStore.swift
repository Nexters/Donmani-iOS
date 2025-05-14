//
//  MonthlyStarBottleStore.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import ComposableArchitecture

@Reducer
struct MonthlyStarBottleStore {
    struct Context {
        let year: Int
        let month: Int
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let record: [Record]
        let year: Int
        let month: Int
        
        init(context: Context) {
            self.year = context.year
            self.month = context.month
            let key = "\(year)-\(String(format: "%02d", month))"
            self.record = (DataStorage.getRecord(yearMonth: key) ?? []).sorted {
                $0.date > $1.date
            }
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
