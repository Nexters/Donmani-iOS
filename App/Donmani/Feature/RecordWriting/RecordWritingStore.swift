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
        
        init(
            type: RecordContentType,
            selectedCategory: RecordCategory? = nil,
            content: RecordContent? = nil
        ) {
            self.type = type
            switch type {
            case .good:
                self.category = GoodCategory.allCases.map { RecordCategory($0) }
            case .bad:
                self.category = BadCategory.allCases.map { RecordCategory($0) }
            }
            self.selectedCategory = selectedCategory
            if let content = content {
                self.sticker = (content.flag == .good ? DImage(.goodLogSelected).image : DImage(.badLogSelected).image)
                self.textCount = content.memo.count
                self.isSaveEnabled = true
            } else {
                self.sticker = (type == .good ? DImage(.defaultGoodSticker).image : DImage(.defaultBadSticker).image)
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
        case save
        case sendToLogView(RecordContent)
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            print("State ---- \n", state)
            print("Action ---- \n", action)
            print(#function, "============================\n\n")
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
                state.selectedCategory = nil
                return .none
            case .closeCategory:
                state.isPresentingSelectCategory = false
                return .none
            case .binding(let bindingState):
                print(bindingState)
                return .none
            case .save:
                UIApplication.shared.endEditing()
                guard let recordContent = state.recordContent else {
                    return .none
                }
                return .run { send in
                    await send(.sendToLogView(recordContent))
                }
            case .sendToLogView(let content):
                return .none
            }
        }
    }
}


