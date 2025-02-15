//
//  RecordEntryPointStore.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import ComposableArchitecture

@Reducer
struct RecordEntryPointStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        
        var goodRecord: RecordContent?
        var badRecord: RecordContent?
        var isCheckedEmptyRecord: Bool = false
        
        var dayType: DayType = .today
        
        var isPresentingCancel: Bool = false
        var isPresentingRecordEmpty: Bool = false
        var isPresentingRecordComplete: Bool = false
        var isPresentingRecordWritingView: Bool = false
        
        var recordWritingState = RecordWritingStore.State(type: .good)
        
        var showDayToggle: Bool
        var title: String
        
        var isSaveEnabled: Bool = false
        
        init(isCompleteToday: Bool, isCompleteYesterday: Bool) {
            self.isCompleteToday = isCompleteToday
            self.isCompleteYesterday = isCompleteYesterday
            self.dayType = isCompleteToday ? .yesterday : .today
            var title = "소비 정리해 볼까요?"
            if !(isCompleteToday || isCompleteYesterday) {
                title = "하루 " + title
            } else if isCompleteToday {
                title = "어제 " + title
            } else {
                title = "오늘 " + title
            }
            self.title = title
            self.showDayToggle = !(isCompleteToday || isCompleteYesterday)
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case showCancelRecordBottomSheet
        case dismissCancelRecordBottomSheet
        case cancelRecording
        
        case editRecordWriting(RecordContent)
        case startRecordWriting(RecordContentType)
        
        case binding(BindingAction<State>)
        
        case touchEmptyRecordButton
        case dismissEmtpyRecordBottomSheet
        case recordEmpty
        
        case setGoodRecord(RecordContent)
        case setBadRecord(RecordContent)
        case setRecord(RecordWritingStore.Action)
        case checkRecord
        
        case showSaveBottomSheet
        case dismissSaveBottomSheet
        case save
        
        case toggleDay
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Scope(
            state: \.recordWritingState,
            action: \.setRecord
        ) {
            RecordWritingStore()
        }
        
        BindingReducer()
        
        Reduce { state, action in
            //            print("State ---- \n", state)
            //            print("Action ---- \n", action)
            //            print(#function, "============================\n\n")
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
            case .editRecordWriting(let content):
                state.recordWritingState = RecordWritingStore.State(type: content.flag, content: content)
                state.isPresentingRecordWritingView = true
                return .none
            case .startRecordWriting(let type):
                state.recordWritingState = RecordWritingStore.State(type: type)
                state.isPresentingRecordWritingView = true
                return .none
            case .binding:
                return .none
                
            case .touchEmptyRecordButton:
                if state.isCheckedEmptyRecord {
                    state.isCheckedEmptyRecord = false
                    state.isSaveEnabled = false
                } else {
                    state.isPresentingRecordEmpty = true
                }
                return .none
                
            case .dismissEmtpyRecordBottomSheet:
                state.isPresentingRecordEmpty = false
                return .none
                
            case .recordEmpty:
                state.isCheckedEmptyRecord = true
                state.isSaveEnabled = true
                state.isPresentingRecordEmpty = false
                state.goodRecord = nil
                state.badRecord = nil
                return .none
                
            case .setGoodRecord(let recordContent):
                state.goodRecord = recordContent
                return .run { send in
                    await send(.checkRecord)
                }
            case .setBadRecord(let recordContent):
                state.badRecord = recordContent
                return .run { send in
                    await send(.checkRecord)
                }
            case .setRecord(let event):
                switch event {
                case .sendToLogView(let content):
                    return .run { send in
                        switch content.flag {
                        case .good:
                            await send(.setGoodRecord(content))
                        case .bad:
                            await send(.setBadRecord(content))
                        }
                    }
                default:
                    return .none
                }
            case .checkRecord:
                if (state.badRecord != nil && state.goodRecord != nil) {
                    state.isSaveEnabled = true
                } else {
                    state.isSaveEnabled = false
                }
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
    
}
