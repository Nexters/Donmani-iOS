//
//  LogReducer.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import ComposableArchitecture

@Reducer
struct LogReducer {
    
    // MARK: - State
    @ObservableState
    struct LogState: Equatable {
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        
        var goToLogGood: Bool = false
        var goToLogBad: Bool = false
        var goToLogEmpty: Bool = false
        
        init(isCompleteToday: Bool, isCompleteYesterday: Bool) {
            self.isCompleteToday = isCompleteToday
            self.isCompleteYesterday = isCompleteYesterday
        }
    }
    
    // MARK: - Action
    enum LogAction: Equatable {
        case logGood
        case logBad
        case logEmpty
        case save
        case toggleDay
    }
    
    // MARK: - Reducer
    var body: some Reducer<LogState, LogAction> {
        Reduce { state, action in
            switch action {
            case .logGood:
                return .none
            case .logBad:
                return .none
            case .logEmpty:
                return .none
            case .save:
                return .none
            case .toggleDay:
                return .none
            }
        }
    }
}
