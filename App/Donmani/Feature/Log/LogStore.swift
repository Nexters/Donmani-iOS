//
//  LogStore.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import ComposableArchitecture

@Reducer
struct LogStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        enum DayType {
            case today
            case yesterday
        }
        
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        
        var goToLogGood: Bool = false
        var goToLogBad: Bool = false
        var goToLogEmpty: Bool = false
        
        var dayType: DayType = .today
        
        var title: String {
            return "\(dayType == .today ? "오늘" : "어제") 소비 정리해 볼까요?"
        }
        
        init(isCompleteToday: Bool, isCompleteYesterday: Bool) {
            self.isCompleteToday = isCompleteToday
            self.isCompleteYesterday = isCompleteYesterday
            if self.isCompleteToday {
                self.dayType = .yesterday
            }
        }
    }
    
    // MARK: - Action
    enum Action: Equatable {
        case logGood
        case logBad
        case logEmpty
        case save
        case toggleDay
    }
    
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
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
    
    
    // MARK: - View
    public static func view(isCompleteToday: Bool, isCompleteYesterday: Bool) -> LogView {
        LogView(
            store: Store(
                initialState: LogStore.State(
                    isCompleteToday: isCompleteToday,
                    isCompleteYesterday: isCompleteYesterday
                )
            ) {
                LogStore()
            }
        )
    }
}
