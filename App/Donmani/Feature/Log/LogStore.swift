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
        
        var goodRecord: RecordContent?
        var badRecord: RecordContent?
        var isEmptyRecord: Bool = false
        
        var dayType: DayType = .today
        
        var isPresentingCancel: Bool = false
        var isPresentingRecordEmpty: Bool = false
        var isPresentingRecordComplete: Bool = false
        
        var isSaveEnabled: Bool {
            return (goodRecord != nil && badRecord != nil) || isEmptyRecord
        }
        
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
        case showCancelRecordBottomSheet
        case dismissCancelRecordBottomSheet
        case cancelRecording
        
        case logGood
        case logBad
        
        case showEmptyRecordBottomSheet
        case dismissEmtpyRecordBottomSheet
        case recordEmpty
        
        case showSaveBottomSheet
        case dismissSaveBottomSheet
        case save
        
        case toggleDay
    }
    
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showCancelRecordBottomSheet:
                state.isPresentingCancel = true
                return .none
            case .dismissCancelRecordBottomSheet:
                state.isPresentingCancel = false
                return .none
            case .cancelRecording:
                state.isPresentingCancel = false
                return .none
                
            case .logGood:
                return .none
            case .logBad:
                return .none
            
            case .showEmptyRecordBottomSheet:
                if state.isEmptyRecord {
                    state.isEmptyRecord = false
                } else {
                    state.isPresentingRecordEmpty = true
                }
                return .none
                
            case .dismissEmtpyRecordBottomSheet:
                state.isPresentingRecordEmpty = false
                return .none
                
            case .recordEmpty:
                state.isEmptyRecord = true
                return .none
                
            case .showSaveBottomSheet:
                state.isPresentingRecordComplete = true
                return .none
            case .dismissSaveBottomSheet:
                state.isPresentingRecordComplete = false
                return .none
                
            case .save:
                state.isPresentingRecordComplete = false
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
