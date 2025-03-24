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
//        var isFocused: Bool = false
        var isPresendTextGuide: Bool = false
        var isFocusToTextField: Bool = false
        
        init(
            type: RecordContentType,
            content: RecordContent? = nil
        ) {
            self.type = type
            var tempCategory: [RecordCategory]
            switch type {
            case .good:
                tempCategory = GoodCategory.allCases.map { RecordCategory($0) }
            case .bad:
                tempCategory = BadCategory.allCases.map { RecordCategory($0) }
            }
            _ = tempCategory.popLast()
            self.category = tempCategory
            self.selectedCategory = content?.category
            self.savedCategory = content?.category
            if let content = content {
                self.sticker = content.category.image
                self.textCount = content.memo.count
                self.text = content.memo
                self.isSaveEnabled = true
            } else {
                self.sticker = (type == .good ? DImage(.defaultGoodSticker) : DImage(.defaultBadSticker)).image
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
                UINavigationController.swipeNavigationPopIsEnabled = false
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
                return .run { send in
                    await send(.closeCategory)
                }
                
            case .closeCategory:
                state.isFocusToTextField = true
                state.isPresentingSelectCategory = false
                UINavigationController.swipeNavigationPopIsEnabled = true
                return .none
                
            case .textChanged(let textCount):
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}


