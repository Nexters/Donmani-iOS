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
    struct State: Equatable {
        let record: [Record]
        init() {
            let yearMonth = DateManager.shared.getFormattedDate(for: .today, .yearMonth)
            self.record = (DataStorage.getRecord(yearMonth: yearMonth) ?? []).sorted {
                $0.date > $1.date
            }
        }
    }
    
    // MARK: - Action
    enum Action {
        case touchRecordButton
        case delegate(Delegate)
        enum Delegate {
            case pushRecordEntryPointView
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .touchRecordButton:
                return .send(.delegate(.pushRecordEntryPointView))
            case .delegate:
                return .none
            }
        }
    }
}
