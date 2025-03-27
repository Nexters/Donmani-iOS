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
        let yearMonth: (year: Int, month: Int)
        
        init() {
            let yearMonth = DateManager.shared.getFormattedDate(
                for: .today, .yearMonth
            ).components(separatedBy: "-")
            self.yearMonth = (Int(yearMonth[0])! % 100, Int(yearMonth[1])!)
            self.record = (DataStorage.getRecord(yearMonth: "\(yearMonth[0])-\(yearMonth[1])") ?? []).sorted {
                $0.date > $1.date
            }
        }
    }
    
    // MARK: - Action
    enum Action {
        case delegate(Delegate)
        enum Delegate {
            case pushBottleListView
            case pushRecordEntryPointView
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
