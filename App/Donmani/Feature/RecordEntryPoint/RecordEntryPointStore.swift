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
        let dayTitle: String
        var guide: String {
            if dayType == .yesterday {
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
            } else {
                return "기록하고 별사탕 받자!"
            }
        }
        var remainingTime: Int
        var isPresentingPopover: Bool
        
        var isSaveEnabled: Bool = false
        var isReadyToSave: Bool = false
        var isFullWriting: Bool = false
        var isLoading: Bool = false
        var isFromMain: Bool = true
        
        var recordWritingState: RecordWritingStore.State = RecordWritingStore.State(type: .good)
        
        init() {
            self.isCompleteToday = false
            self.isCompleteYesterday = false
            self.dateString = DateManager.shared.getFormattedDate(for: .today)
            self.isPresentingDayToggle = true
            self.title = "하루 소비 정리해 볼까요?"
            self.dayTitle = "하루"
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
            if !(isCompleteToday || isCompleteYesterday) {
                self.dayTitle = "하루"
            } else if isCompleteToday {
                self.dayTitle = "어제"
            } else {
                self.dayTitle = "오늘"
            }
            self.title = "\(self.dayTitle) 소비 정리해 볼까요?"
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
        case sendCancelGAEvent
        
        case dismissRecordGuideBottomSheet
        
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
            // Record Writing
            case pushRecordWritingView(RecordContentType)
            case pushRecordWritingViewWith(RecordContent)
            case popToMainView(Record?)
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
                UINavigationController.blockSwipe = false
                return .none
            case .cancelRecording:
                state.isPresentingCancel = false
                if state.isChangingDayType {
                    return .run { send in
                        await send(.toggleDayType)
                    }
                } else {
                    UINavigationController.swipeNavigationPopIsEnabled = true
                    UINavigationController.blockSwipe = false
                    return .run { send in
                        await send(.delegate(.popToMainView(nil)))
                    }
                }
                
            case .sendCancelGAEvent:
                var parameters: [GA.Parameter: Any] = [.referrer: "기록"]
                if let good = state.goodRecord {
                    parameters = [.good: good.category.title]
                }
                if let bad = state.badRecord {
                    parameters = [.bad: bad.category.title]
                }
                GA.View(event: .recordmainBackBottomsheet).send(parameters: parameters)
                return .none
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
                    GA.Click(event: .recordmainYesterdayButton).send(parameters: [.screenType: "하루"])
                    state.dayType = .yesterday
                    state.dateString = DateManager.shared.getFormattedDate(for: .yesterday)
                case .yesterday:
                    GA.Click(event: .recordmainTodayButton).send(parameters: [.screenType: "하루"])
                    state.dayType = .today
                    state.dateString = DateManager.shared.getFormattedDate(for: .today)
                }
                state.isCheckedEmptyRecord = false
                state.goodRecord = nil
                state.badRecord = nil
                UINavigationController.swipeNavigationPopIsEnabled = true
                UINavigationController.blockSwipe = false
                return .none
            case .touchEmptyRecordButton:
                state.isPresentingPopover = false
                if state.isCheckedEmptyRecord {
                    state.isCheckedEmptyRecord = false
                    state.isSaveEnabled = false
                    GA.Click(event: .recordmainEmptyButtonUncheck).send(parameters: [.screenType: state.dayType])
                    UINavigationController.swipeNavigationPopIsEnabled = true
                } else {
                    GA.Click(event: .recordmainEmptyButton).send(parameters: [.screenType: state.dayType])
                    state.isPresentingRecordEmpty = true
                }
                return .none
            case .closePopover:
                state.isPresentingPopover = false
                HistoryStateManager.shared.setEmptyRecordGuideKey()
                return .none
            case .dismissEmtpyRecordBottomSheet:
                GA.Click(event: .recordmainEmptyNoButton).send(parameters: [.screenType: state.dayTitle])
                state.isPresentingRecordEmpty = false
                UINavigationController.blockSwipe = false
                return .none
                
            case .recordEmpty:
                GA.Click(event: .recordmainEmptyYesButton).send(parameters: [.screenType: state.dayTitle])
                state.isCheckedEmptyRecord = true
                state.isSaveEnabled = true
                state.isPresentingRecordEmpty = false
                state.goodRecord = nil
                state.badRecord = nil
                UINavigationController.blockSwipe = false
                UINavigationController.swipeNavigationPopIsEnabled = false
                return .none
                
            case .readyToSave:
                GA.Click(event: .recordmainSubmitButton).send(parameters: [.screenType: state.dayTitle])
                GA.View(event: .confirm).send(parameters: [.referrer: true])
                
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
                var gaParameter:[GA.Parameter:Any] = [.screenType:state.dayType]
                if let good = state.goodRecord {
                    gaParameter = [.good: good.category.title]
                }
                if let bad = state.badRecord {
                    gaParameter = [.bad: bad.category.title]
                }
                if state.isCheckedEmptyRecord {
                    gaParameter = [.empty: true]
                }
                GA.Click(event: .confirmBackButton).send(parameters: gaParameter)
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
                
                var gaParameter:[GA.Parameter:Any] = [.screenType:state.dayType]
                var recordValue: String = ""
                if let good = state.goodRecord {
                    gaParameter = [.good: good.category]
                    recordValue += "GOOD_" + good.memo
                }
                if let bad = state.badRecord {
                    gaParameter = [.bad: bad.category]
                    recordValue += "BAD_" + bad.memo
                }
                if state.isCheckedEmptyRecord {
                    gaParameter = [.empty: true]
                }
                if !recordValue.isEmpty {
                    gaParameter = [.record: recordValue]
                }
                GA.Click(event: .confirmSubmitButton).send(parameters: gaParameter)
                
                let yesterday = DateManager.shared.getFormattedDate(for: .yesterday, .yearMonthDay)
                let lastDate = HistoryStateManager.shared.getLastWriteRecordDateKey()
                if (yesterday == lastDate) {
                    let streakCount = HistoryStateManager.shared.getStreakSubmitCountKey()
                    gaParameter = [.screenType: state.dayType]
                    if let good = state.goodRecord {
                        gaParameter = [.good: good.category]
                    }
                    if let bad = state.badRecord {
                        gaParameter = [.bad: bad.category]
                    }
                    gaParameter[.streakCount] = streakCount + 1
                    HistoryStateManager.shared.setStreakSubmitCountKey(count: streakCount + 1)
                    HistoryStateManager.shared.setLastWriteRecordDateKey()
                    GA.Submit(event: .streakSubmit).send(parameters: gaParameter)
                }
                return .run { send in
                    let requestDTO = NetworkRequestDTOMapper.mapper(data: records)
                    guard let _ = try? await NetworkService.DRecord().insert(date: date, recordContent: requestDTO) else {
                        await send(.errorSave)
                        return
                    }
                    let record = Record(date: date, contents: records)
                    await send(.delegate(.popToMainView(record)))
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
                
            case .delegate(.pushRecordWritingView(let type)):
                switch type {
                case .good:
                    GA.Click(event: .recordmainGoodButton).send(parameters: [.screenType: state.dayTitle])
                case .bad:
                    GA.Click(event: .recordmainBadButton).send(parameters: [.screenType: state.dayTitle])
                }
                return .none
            case .delegate:
                return .none
            }
        }
    }
    
}
