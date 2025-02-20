//
//  RecordListStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import ComposableArchitecture

@Reducer
struct RecordListStore {
    
    // MARK: - State
    @ObservableState
    struct State {
        let record: [Record]
        init() {
            let yearMonth = DateManager.shared.getFormattedDate(for: .today, .yearMonth)
            self.record = DataStorage.getRecord(yearMonth: yearMonth) ?? []
        }
    }
    
    // MARK: - Action
    enum Action {
        
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
