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
    
    struct Context {
        let isCompleteToday: Bool
        let isCompleteYesterday: Bool
        init(today isCompleteToday: Bool, yesterday isCompleteYesterday: Bool) {
            self.isCompleteToday = isCompleteToday
            self.isCompleteYesterday = isCompleteYesterday
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        var isCompleteToday: Bool
        var isCompleteYesterday: Bool
        
        var record: Record?
        var goodRecord: RecordContent?
        var badRecord: RecordContent?
        var isCheckedEmptyRecord: Bool = false
        
        var selectedDay: Day
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
                    var text = "\(seconds)초 안에 별사탕 받자!"
                    if hours > 0 {
                        text = "\(hours)시간 \(minutes)분 " + text
                    } else {
                        if minutes > 0 {
                            text = "\(minutes)분 " + text
                        }
                    }
                    return text
                }
            } else {
                return "기록하고 별사탕 받자!"
            }
        }
        var remainingTime: Int
        var isPresentingEmptyRecordToolTip: Bool = false
        
        var isSaveEnabled: Bool = false
        var isReadyToSave: Bool = false
        var isFullWriting: Bool = false
        var isLoading: Bool = false
        var isError: Bool = false
        
        init(context: Context) {
            self.isPresentingRecordGuideView = (HistoryStateManager.shared.getGuideState() == nil)
            self.isCompleteToday = context.isCompleteToday
            self.isCompleteYesterday = context.isCompleteYesterday
            self.dayType = context.isCompleteToday ? .yesterday : .today
            if !(context.isCompleteToday || context.isCompleteYesterday) {
                self.dayTitle = "하루"
            } else if context.isCompleteToday {
                self.dayTitle = "어제"
            } else {
                self.dayTitle = "오늘"
            }
            self.title = "\(self.dayTitle) 소비 정리해 볼까요?"
            self.selectedDay = context.isCompleteToday ? .yesterday : .today
            self.isPresentingDayToggle = !(context.isCompleteToday || context.isCompleteYesterday)
            self.remainingTime = TimeManager.getRemainingTime()
        }
        
        mutating func updateRecordContent(content: RecordContent) {
            switch content.flag {
            case .good:
                self.goodRecord = content
            case .bad:
                self.badRecord = content
            }
            self.isSaveEnabled = true
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
        case dismissEmptyRecordBottomSheet
        case recordEmpty
        
        case readyToSave
        case cancelSave
        case errorSave
        case completeWrite
        
        case startTimer
        case checkRemainingTime
        case updateTime(Int)
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            // Record Writing
            case pushRecordWritingView(RecordContentType)
            case pushRecordWritingViewWith(RecordContent)
            case popToMainView
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.settings) var settings
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showCancelRecordBottomSheet:
                state.isPresentingCancel = true
                
            case .dismissCancelRecordBottomSheet:
                state.isPresentingCancel = false
                state.isChangingDayType = false
                UINavigationController.isBlockSwipe = false

            case .cancelRecording:
                state.isPresentingCancel = false
                if state.isChangingDayType {
                    return .run { send in
                        await send(.toggleDayType)
                    }
                } else {
                    UINavigationController.isBlockSwipe = false
                    return .run { send in
                        await send(.delegate(.popToMainView))
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
                
            case .dismissRecordGuideBottomSheet:
                state.isPresentingRecordGuideView = false
                HistoryStateManager.shared.setGuideState()
                
            case .touchDayTypeToggleButton:
                if (state.isCheckedEmptyRecord || state.goodRecord != nil || state.badRecord != nil) {
                    state.isChangingDayType = true
                    state.isPresentingCancel = true
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
                    state.selectedDay = .yesterday
                case .yesterday:
                    GA.Click(event: .recordmainTodayButton).send(parameters: [.screenType: "하루"])
                    state.dayType = .today
                    state.selectedDay = .today
                }
                state.isCheckedEmptyRecord = false
                
                state.goodRecord = nil
                state.badRecord = nil
                state.isSaveEnabled = false
                UINavigationController.isBlockSwipe = false

            case .touchEmptyRecordButton:
                state.isPresentingEmptyRecordToolTip = false
                if state.isCheckedEmptyRecord {
                    state.isCheckedEmptyRecord = false
                    state.isSaveEnabled = false
                    GA.Click(event: .recordmainEmptyButtonUncheck).send(parameters: [.screenType: state.dayType])
                    UINavigationController.isBlockSwipe = false
                } else {
                    GA.Click(event: .recordmainEmptyButton).send(parameters: [.screenType: state.dayType])
                    state.isPresentingRecordEmpty = true
                }

            case .closePopover:
                state.isPresentingEmptyRecordToolTip = false
                settings.shouldShowEmptyRecordToolTip = false
                
            case .dismissEmptyRecordBottomSheet:
                GA.Click(event: .recordmainEmptyNoButton).send(parameters: [.screenType: state.dayTitle])
                state.isPresentingRecordEmpty = false
                UINavigationController.isBlockSwipe = false
                
            case .recordEmpty:
                GA.Click(event: .recordmainEmptyYesButton).send(parameters: [.screenType: state.dayTitle])
                state.isCheckedEmptyRecord = true
                state.isSaveEnabled = true
                state.isPresentingRecordEmpty = false
                state.goodRecord = nil
                state.badRecord = nil
                UINavigationController.isBlockSwipe = true
                
            case .readyToSave:
                GA.Click(event: .recordmainSubmitButton).send(parameters: [.screenType: state.dayTitle])
                GA.View(event: .confirm).send(parameters: [.screenType: state.dayTitle])
                
                
                state.isReadyToSave = true
                state.isFullWriting = true
                if !state.isCheckedEmptyRecord {
                    if (state.goodRecord == nil || state.badRecord == nil) {
                        state.isFullWriting = false
                    }
                }

            case .cancelSave:
                state.isReadyToSave = false
                var gaParameter: [GA.Parameter:Any] = [.screenType:state.dayType]
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
            
            case .errorSave:
                state.isLoading = false
                state.isError = true
                
            case .completeWrite:
                state.isLoading = true
                var buffer: [RecordContent]? = nil
                if (state.badRecord != nil || state.goodRecord != nil) {
                    buffer = [state.goodRecord, state.badRecord].compactMap{$0}
                }
                let records = buffer
                let stateManager = HistoryStateManager.shared
                stateManager.addRecord(for: state.dayType)
                
                var gaParameter:[GA.Parameter: Any] = [.screenType: state.dayType]
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
                let record = Record(
                    day: state.selectedDay,
                    records: records ?? []
                )
                state.record = record
                recordRepository.save(record)
                state.isError = false
                return .run { send in
                    try await recordRepository.postRecord(record: record)
                }
                
            case .startTimer:
                state.isPresentingEmptyRecordToolTip = settings.shouldShowEmptyRecordToolTip
                let isBlockSwipe = !(state.goodRecord == nil && state.badRecord == nil)
                UINavigationController.isBlockSwipe = isBlockSwipe
                return .run { send in
                    while true {
                        let remainingTime = TimeManager.getRemainingTime()
                        await send(.updateTime(remainingTime))
                        try await Task.sleep(nanoseconds: .nanosecondsPerSecond)
                    }
                }
                .cancellable(id: "Timer", cancelInFlight: true)
                
            case .checkRemainingTime:
                let remainingTime = TimeManager.getRemainingTime()
                return .send(.updateTime(remainingTime))
            
            case .updateTime(let seconds):
                state.remainingTime = seconds
                if seconds == 0 {
                    return .cancel(id: "Timer")
                }
                
            case .delegate(.pushRecordWritingView(let type)):
                switch type {
                case .good: GA.Click(event: .recordmainGoodButton).send(parameters: [.screenType: state.dayTitle])
                case .bad:  GA.Click(event: .recordmainBadButton).send(parameters: [.screenType: state.dayTitle])
                }

            default:
                break
            }
            
            return .none
        }
    }
    
}
