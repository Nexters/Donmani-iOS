//
//  RecordEntryPointStore.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import UIKit
import ComposableArchitecture
import DNetwork

@Reducer
struct RecordEntryPointStore {
    let scheduler = DispatchQueue.main.eraseToAnyScheduler()
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        
        var goodRecord: RecordContent?
        var badRecord: RecordContent?
        var isCheckedEmptyRecord: Bool = false
        
        var dateString: String
        var dayType: DayType = .today
        
        var isPresentingCancel: Bool = false
        var isPresentingRecordEmpty: Bool = false
        var isPresentingRecordWritingView: Bool = false
        var isPresentingRecordGuideView: Bool = false
        
        var recordWritingState = RecordWritingStore.State(type: .good)
        
        var isPresentingDayToggle: Bool
        var title: String
        var guide: String {
            if remainingTime > 7200 {
                return "기록하고 별사탕 받자!"
            } else if remainingTime <= 0 {
                return "기록을 마무리하면 별사탕을 받을 수 있어요!"
            } else {
                let hours = remainingTime / 3600
                let minutes = (remainingTime % 3600) / 60
                let seconds = remainingTime % 60
                return "\(hours)시간 \(minutes)분 \(seconds)초 안에 별사탕 받자!"
            }
        }
        var remainingTime: Int
        var isPresentingPopover: Bool
        
        var isSaveEnabled: Bool = false
        var isReadyToSave: Bool = false
        var isLoading: Bool = false
        var isFromMain: Bool = true
        
        init() {
            self.isCompleteToday = false
            self.isCompleteYesterday = false
            self.dateString = DateManager.shared.getFormattedDate(for: .today)
            self.isPresentingDayToggle = true
            self.title = "하루 소비 정리해 볼까요?"
            self.remainingTime = TimeManager.getRemainingTime()
            self.isPresentingPopover = true
        }
        
        init(isCompleteToday: Bool, isCompleteYesterday: Bool, isFromMain: Bool = true) {
            self.isFromMain = isFromMain
            self.isPresentingRecordGuideView = (HistoryStateManager.shared.getGuideState() == nil)
            self.isPresentingPopover = HistoryStateManager.shared.getEmptyRecordGuideKey()
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
            self.dateString = DateManager.shared.getFormattedDate(for: isCompleteToday ? .yesterday : .today)
            self.isPresentingDayToggle = !(isCompleteToday || isCompleteYesterday)
            self.remainingTime = TimeManager.getRemainingTime()
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case showCancelRecordBottomSheet
        case dismissCancelRecordBottomSheet
        case cancelRecording
        
        case dismissRecordGuideBottomSheet
        
        case editRecordWriting(RecordContent)
        case startRecordWriting(RecordContentType)
        
        case binding(BindingAction<State>)
        
        case touchYesterdayToggleButton
        case touchTodayToggleButton
        
        case touchEmptyRecordButton
        case closePopover
        case dismissEmtpyRecordBottomSheet
        case recordEmpty
        
        case setGoodRecord(RecordContent)
        case setBadRecord(RecordContent)
        case setRecord(RecordWritingStore.Action)
        case checkRecord
        
        case readyToSave
        case cancelSave
        case errorSave
        case save
        
        
        case startTimer
        case checkRemainingTime
        case updateTime(Int)
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case popToMainViewWith(Record)
            case popToMainView
        }
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
                
            case .dismissRecordGuideBottomSheet:
                state.isPresentingRecordGuideView = false
                HistoryStateManager.shared.setGuideState()
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
                
            case .touchYesterdayToggleButton:
                state.dayType = .yesterday
                state.dateString = DateManager.shared.getFormattedDate(for: .yesterday)
                return .none
            case .touchTodayToggleButton:
                state.dayType = .today
                state.dateString = DateManager.shared.getFormattedDate(for: .today)
                return .none
                
            case .touchEmptyRecordButton:
                state.isPresentingPopover = false
                if state.isCheckedEmptyRecord {
                    state.isCheckedEmptyRecord = false
                    state.isSaveEnabled = false
                } else {
                    state.isPresentingRecordEmpty = true
                }
                return .none
            case .closePopover:
                state.isPresentingPopover = false
                HistoryStateManager.shared.setEmptyRecordGuideKey()
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
                case .sendToRecordView(let content):
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
                
            case .readyToSave:
                state.isReadyToSave = true
                UINavigationController.swipeNavigationPopIsEnabled = false
                return .none
            case .cancelSave:
                state.isReadyToSave = false
                UINavigationController.swipeNavigationPopIsEnabled = true
                return .none
            case .save:
                state.isLoading = true
                var buffer: [RecordContent]? = nil
                if (state.badRecord != nil && state.goodRecord != nil) {
                    buffer = [state.goodRecord!, state.badRecord!]
                }
                let records = buffer
                let date = state.dateString
                let stateManager = HistoryStateManager.shared
                stateManager.addRecord(for: state.dayType)
                return .run { send in
                    let networkManager = NetworkManager.NMRecord(service: .shared)
                    guard let _ = try? await networkManager.uploadRecord(date: date, recordContent: records) else {
                        await send(.errorSave)
                        return
                    }
                    let record = Record(date: date, contents: records)
                    await send(.delegate(.popToMainViewWith(record)))
                }
            case .errorSave:
                state.isLoading = false
                return .none
            case .startTimer:
                return .run { send in
                    while true {
                        let remainingTime = TimeManager.getRemainingTime()
                        await send(.updateTime(remainingTime))
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                    }
                }
                .cancellable(id: "Timer", cancelInFlight: true)
                
            case .updateTime(let seconds):
                state.remainingTime = seconds
                if seconds == 0 {
                    return .cancel(id: "Timer")
                }
                return .none
                
            case .checkRemainingTime:
                let remainingTime = TimeManager.getRemainingTime()
                return .send(.updateTime(remainingTime))
            case .delegate:
                return .none
            }
        }
    }
    
}
