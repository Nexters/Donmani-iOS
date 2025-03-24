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
        var isChangingDayType = false
        
        var isPresentingCancel: Bool = false
        var isPresentingRecordEmpty: Bool = false
        var isPresentingRecordWritingView: Bool = false
        var isPresentingRecordGuideView: Bool = false
        
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
        var isFullWriting: Bool = false
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
    enum Action: BindableAction {
        case showCancelRecordBottomSheet
        case dismissCancelRecordBottomSheet
        case cancelRecording
        
        case dismissRecordGuideBottomSheet
//        case touchYesterdayToggleButton
//        case touchTodayToggleButton
        
        case touchDayTypeToggleButton
        case toggleDayType
        
        case touchEmptyRecordButton
        case closePopover
        case dismissEmtpyRecordBottomSheet
        case recordEmpty
        
        case readyToSave
        case cancelSave
        case errorSave
        case save
        
        case startTimer
        case checkRemainingTime
        case updateTime(Int)
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate: Equatable {
            case pushRecordWritingView(RecordContentType)
            case pushRecordWritingViewWith(RecordContent)
            case popToMainView
            case popToMainViewWith(Record)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showCancelRecordBottomSheet:
                state.isPresentingCancel = true
                return .none
            case .dismissCancelRecordBottomSheet:
                state.isPresentingCancel = false
                state.isChangingDayType = false
                return .none
            case .cancelRecording:
                state.isPresentingCancel = false
                if state.isChangingDayType {
                    return .run { send in
                        await send(.toggleDayType)
                    }
                } else {
                    return .run { send in
                        await send(.delegate(.popToMainView))
                    }
                }
            case .dismissRecordGuideBottomSheet:
                state.isPresentingRecordGuideView = false
                HistoryStateManager.shared.setGuideState()
                return .none
                
            case .touchDayTypeToggleButton:
                if (state.isCheckedEmptyRecord || state.goodRecord != nil || state.badRecord != nil) {
                    state.isChangingDayType = true
                    state.isPresentingCancel = true
                    return .none
                } else {
                    return .run { send in
                        await send(.toggleDayType)
                    }
                }
                
            case .toggleDayType:
                state.isChangingDayType = false
                switch state.dayType {
                case .today:
                    state.dayType = .yesterday
                    state.dateString = DateManager.shared.getFormattedDate(for: .yesterday)
                case .yesterday:
                    state.dayType = .today
                    state.dateString = DateManager.shared.getFormattedDate(for: .today)
                }
                state.isCheckedEmptyRecord = false
                state.goodRecord = nil
                state.badRecord = nil
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
                
            case .readyToSave:
                state.isReadyToSave = true
                state.isFullWriting = true
                if !state.isCheckedEmptyRecord {
                    if (state.goodRecord == nil || state.badRecord == nil) {
                        state.isFullWriting = false
                    }
                }
                UINavigationController.swipeNavigationPopIsEnabled = false
                return .none
            case .cancelSave:
                state.isReadyToSave = false
                return .none
            case .save:
                state.isLoading = true
                var buffer: [RecordContent]? = nil
                if (state.badRecord != nil || state.goodRecord != nil) {
                    buffer = [state.goodRecord, state.badRecord].compactMap{$0}
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
                
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
    }
    
}
