//
//  RecordWritingStore.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@Reducer
struct RecordWritingStore {
    
    struct Context {
        let type: RecordContentType
        let content: RecordContent?
        init(type: RecordContentType, content: RecordContent? = nil) {
            self.type = type
            self.content = content
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var category: [RecordCategory]
        
        var sticker: Image
        var textCount: Int = 0
        
        var isSaveEnabled: Bool = false
        var recordContent: RecordContent?
        
        var type: RecordContentType
        var selectedCategory: RecordCategory?
        var savedCategory: RecordCategory?
        var text: String = ""
        var isPresentingSelectCategory: Bool = false
        var isPresentingCancel: Bool = false
        var isPresendTextGuide: Bool = false
        var isFocusToTextField: Bool = false
        
        let dayTitle: String

        init(context: Context) {
            self.type = context.type
            var tempCategory: [RecordCategory]
            switch context.type {
            case .good:
                tempCategory = GoodCategory.allCases.map { RecordCategory($0) }
            case .bad:
                tempCategory = BadCategory.allCases.map { RecordCategory($0) }
            }
            
            let stateManager = HistoryStateManager.shared.getState()
            let isCompleteToday = stateManager[.today, default: false]
            let isCompleteYesterday = stateManager[.yesterday, default: false]
            if !(isCompleteToday || isCompleteYesterday) {
                self.dayTitle = "하루"
            } else if isCompleteToday {
                self.dayTitle = "어제"
            } else {
                self.dayTitle = "오늘"
            }
            
            _ = tempCategory.popLast()
            self.category = tempCategory
            self.recordContent = context.content
            self.selectedCategory = context.content?.category
            self.savedCategory = context.content?.category
            if let content = context.content {
                self.sticker = content.category.image
                self.textCount = content.memo.count
                self.text = content.memo
                self.isSaveEnabled = true
            } else {
                self.sticker = (context.type == .good ? DImage(.defaultGoodSticker) : DImage(.defaultBadSticker)).image
            }
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case openCategory
        case selectCategory(RecordCategory)
        case saveCategory(RecordCategory)
        case closeCategory
        case textChanged(Int)
        case showTextLengthGuide
        case hideTextLengthGuide
        case save(String)
        case showCancelRecordBottomSheet
        case dismissCancelRecordBottomSheet(Bool)
        case sendCancelGAEvent
        case touchWriteNextTime
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case popToRecordEntrypointView
            case popToRecordEntrypointViewWith(RecordContent)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .openCategory:
                UIApplication.shared.endEditing()
                state.isPresentingSelectCategory = true
                state.selectedCategory = state.savedCategory
                return .none
                
            case .selectCategory(let category):
                state.selectedCategory = category
                return .none
                
            case .saveCategory(let category):
                state.savedCategory = category
                state.sticker = category.image
                state.selectedCategory = nil
                if (state.textCount > 0) {
                    state.isSaveEnabled = true
                }
                if let originCategory = state.recordContent?.category {
                    UINavigationController.swipeNavigationPopIsEnabled = (originCategory == category)
                }
                return .run { send in
                    await send(.closeCategory)
                }
                
            case .closeCategory:
                state.isFocusToTextField = true
                state.isPresentingSelectCategory = false
                UINavigationController.blockSwipe = false
                return .none
                
            case .textChanged(let textCount):
                HapticManager.shared.playHapticTransient()
                state.textCount = textCount
                state.isSaveEnabled = (textCount > 0 && state.savedCategory != nil)
                return .none
                
            case .showTextLengthGuide:
                if (state.isPresendTextGuide) {
                    return .none
                }
                state.isPresendTextGuide = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    await send(
                        .hideTextLengthGuide,
                        animation: .linear(duration: 0.5)
                    )
                }
            case .hideTextLengthGuide:
                state.isPresendTextGuide = false
                return .none
            case .save(let text):
                UIApplication.shared.endEditing()
                if let savedCategory = state.savedCategory {
                    let recordContent = RecordContent(flag: state.type, category: savedCategory, memo: text)
                    return .run { send in
                        await send(.delegate(.popToRecordEntrypointViewWith(recordContent)))
                    }
                }
                return .none
                
            case .showCancelRecordBottomSheet:
                state.isPresentingCancel = true
                return .none
                
            case .dismissCancelRecordBottomSheet(let isContinue):
                var gaParameter: [GA.Parameter: Any] = [.screenType: state.dayTitle]
                if let savedCategory = state.savedCategory {
                    switch state.type {
                    case .good:
                        gaParameter[.good] = (savedCategory.getInstance() as GoodCategory?)?.title ?? "Good"
                    case .bad:
                        gaParameter[.bad] = (savedCategory.getInstance() as BadCategory?)?.title ?? "Bad"
                    }
                }
                if isContinue {
                    GA.Click(event: .recordContinueButton).send(parameters: gaParameter)
                } else {
                    GA.Click(event: .recordBackButton).send(parameters: gaParameter)
                }
                state.isFocusToTextField = true
                state.isPresentingCancel = false
                UINavigationController.blockSwipe = false
                return .none
            case .sendCancelGAEvent:
                var parameters: [GA.Parameter: Any] = [.referrer: "기록작성"]
                if let savedCategory = state.savedCategory {
                    switch state.type {
                    case .good:
                        parameters[.good] = (savedCategory.getInstance() as GoodCategory?)?.title ?? "Good"
                    case .bad:
                        parameters[.bad] = (savedCategory.getInstance() as BadCategory?)?.title ?? "Bad"
                    }
                }
                GA.View(event: .recordmainBackBottomsheet).send(parameters: parameters)
                return .none
            case .touchWriteNextTime:
                var parameters: [GA.Parameter: Any] = [.screenType: state.dayTitle]
                switch state.type {
                case .good:
                    parameters[.good] = (state.savedCategory?.getInstance() as GoodCategory?)?.title ?? "Good"
                case .bad:
                    parameters[.bad] = (state.savedCategory?.getInstance() as BadCategory?)?.title ?? "Bad"
                }
                GA.Click(event: .recordNexttimeButton).send(parameters: parameters)
                return .none
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}


