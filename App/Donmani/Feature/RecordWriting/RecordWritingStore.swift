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
        var isFocused: Bool = false
        var isPresendTextGuide: Bool = false
        
        init(
            type: RecordContentType,
            content: RecordContent? = nil
        ) {
            self.type = type
            switch type {
            case .good:
                self.category = GoodCategory.allCases.map { RecordCategory($0) }
            case .bad:
                self.category = BadCategory.allCases.map { RecordCategory($0) }
            }
            self.selectedCategory = content?.category
            self.savedCategory = content?.category
            if let content = content {
                self.sticker = (content.flag == .good ? DImage(.goodLogSelected) : DImage(.badLogSelected)).image
                self.textCount = content.memo.count
                self.text = content.memo
                self.isSaveEnabled = true
            } else {
                self.sticker = (type == .good ? DImage(.defaultGoodSticker) : DImage(.defaultBadSticker)).image
            }
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case openCategory
        case selectCategory(RecordCategory)
        case saveCategory(RecordCategory)
        case closeCategory
        case binding(BindingAction<State>)
        case textChanged
        case save
        case sendToLogView(RecordContent)
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            //            print("State ---- \n", state)
            //            print("Action ---- \n", action)
            //            print(#function, "============================\n\n")
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
                state.sticker = (state.type == .good ? DImage(.goodLogSelected) : DImage(.badLogSelected)).image
                state.selectedCategory = nil
                state.isPresentingSelectCategory = false
                if (state.textCount > 0) {
                    state.isSaveEnabled = true
                }
                return .none
                
            case .closeCategory:
                state.isPresentingSelectCategory = false
                return .none
                
            case .binding(_):
                return .run { send in await send(.textChanged) }
                
            case .textChanged:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                state.textCount = state.text.count
                state.isSaveEnabled = (state.textCount > 0 && state.savedCategory != nil)
                if state.textCount > 100 {
                    state.text = String(state.text.prefix(100))
                    state.isPresendTextGuide = true
                }
                if state.textCount >= 100 {
                    state.isPresendTextGuide = true
                } else {
                    state.isPresendTextGuide = false
                }
                return .none
                
            case .save:
                UIApplication.shared.endEditing()
                if let savedCategory = state.savedCategory {
                    let recordContent = RecordContent(flag: state.type, category: savedCategory, memo: state.text)
                    return .run { send in
                        await send(.sendToLogView(recordContent))
                    }
                }
                return .none
            case .sendToLogView(let content):
                print(content)
                return .none
            }
        }
    }
}


