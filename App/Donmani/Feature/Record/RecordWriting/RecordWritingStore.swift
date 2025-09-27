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
    struct State {
        let type: RecordContentType
        let category: [RecordCategory]
        
        var sticker: Image
        var textCount: Int = 0
        
        var isSaveEnabled: Bool = false
        var recordContent: RecordContent?
        var selectedCategory: RecordCategory?
        var savedCategory: RecordCategory?
        var text: String = ""
        var isPresentingSelectCategory: Bool = false
        var isPresentingCancel: Bool = false
        var isPresentingTextGuide: Bool = false
        var isFocusToTextField: Bool = false
        
        let dayTitle: String

        init(context: Context) {
            self.type = context.type
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
            
            self.category = switch context.type {
            case .good: RecordCategory.goodCategory
            case .bad: RecordCategory.badCategory
            }
            self.recordContent = context.content
            self.selectedCategory = context.content?.category
            self.savedCategory = context.content?.category
            if let content = context.content {
                self.sticker = content.category.image
                self.textCount = content.memo.count
                self.text = content.memo
                self.isSaveEnabled = true
            } else {
                self.sticker = DImage(context.type == .good ? .goodPlaceholder : .badPlaceholder).image
            }
            UINavigationController.isBlockSwipe = false
        }
        
        func isBlockSwipe() -> Bool {
            guard let previous = recordContent else {
                return savedCategory != nil || text.isNotEmpty
            }
            
            let isCategoryChanged = previous.category != savedCategory
            let isMemoChanged = previous.memo != text
            return isCategoryChanged || isMemoChanged
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
        case completeWrite(String)
        case showCancelRecordBottomSheet
        case dismissCancelRecordBottomSheet(Bool)
        case sendCancelGAEvent
        case touchWriteNextTime
        
        case binding(BindingAction<State>)
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
                
            case .selectCategory(let category):
                state.selectedCategory = category
                
            case .saveCategory(let category):
                state.savedCategory = category
                state.sticker = category.image
                state.selectedCategory = nil
                if (state.textCount > 0) {
                    state.isSaveEnabled = true
                }
                UINavigationController.isBlockSwipe = state.isBlockSwipe()
                return .run { send in
                    await send(.closeCategory)
                }
                
            case .closeCategory:
                state.isFocusToTextField = true
                state.isPresentingSelectCategory = false
                UINavigationController.isBlockSwipe = state.isBlockSwipe()
                
            case .textChanged(let textCount):
                HapticManager.shared.playHapticTransient()
                state.textCount = textCount
                state.isSaveEnabled = (textCount > 0 && state.savedCategory != nil)
                UINavigationController.isBlockSwipe = state.isBlockSwipe()
                
            case .showTextLengthGuide:
                if (!state.isPresentingTextGuide) {
                    state.isPresentingTextGuide = true
                    return .run { send in
                        try await Task.sleep(nanoseconds: 3_000_000_000)
                        await send(
                            .hideTextLengthGuide,
                            animation: .linear(duration: 0.5)
                        )
                    }
                }
                
            case .hideTextLengthGuide:
                state.isPresentingTextGuide = false
                
            case .completeWrite(let text):
                UIApplication.shared.endEditing()
                if let savedCategory = state.savedCategory {
                    state.recordContent =  RecordContent(
                        flag: state.type,
                        category: savedCategory,
                        memo: text
                    )
                }
                
            case .showCancelRecordBottomSheet:
                state.isPresentingCancel = true
                
            case .dismissCancelRecordBottomSheet(let isContinue):
                let gaParameter: [GA.Parameter: Any] = [
                    .screenType: state.dayTitle,
                    state.type.gaParameter: state.savedCategory?.title ?? ""
                ]
                GA.Click(
                    event: isContinue ? .recordContinueButton : .recordBackButton
                ).send(parameters: gaParameter)
                state.isFocusToTextField = true
                state.isPresentingCancel = false
                UINavigationController.isBlockSwipe = state.isBlockSwipe()

            case .sendCancelGAEvent:
                let parameters: [GA.Parameter: Any] = [
                    .referrer: "기록작성",
                    state.type.gaParameter: state.savedCategory?.title ?? ""
                ]
                GA.View(event: .recordmainBackBottomsheet).send(parameters: parameters)
                
            case .touchWriteNextTime:
                let parameters: [GA.Parameter: Any] = [
                    .screenType: state.dayTitle,
                    state.type.gaParameter: state.savedCategory?.title ?? ""
                ]
                GA.Click(event: .recordNexttimeButton).send(parameters: parameters)
            
            default:
                break
            }
            return .none
        }
    }
    
    
}


