//
//  LogWritingStore.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem


@Reducer
struct LogWritingStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var category: [RecordCategory] {
            switch self.type {
            case .good:
                return GoodCategory.allCases.map { RecordCategory($0) }
            case .bad:
                return BadCategory.allCases.map { RecordCategory($0) }
            }
        }
        
        var sticker: Image {
            switch self.type {
            case .good:
                return DImage(.defaultGoodSticker).image
            case .bad:
                return DImage(.defaultBadSticker).image
            }
        }
        
        var textCount: Int {
            return text.count
        }
        
        var type: RecordContentType
        var selectedCategory: RecordCategory?
        var text: String = ""
        var isPresentingSelectCategory: Bool = false
        
        init(type: RecordContentType, selectedCategory: RecordCategory? = nil) {
            self.type = type
            self.selectedCategory = selectedCategory
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
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .openCategory:
                state.isPresentingSelectCategory = true
                return .none
            case .selectCategory(let category):
                return .none
            case .saveCategory(let category):
                return .none
            case .closeCategory:
                state.isPresentingSelectCategory = false
                return .none
            case .binding(let bindingState):
                print(bindingState)
                return .none
            case .save:
                return .none
            }
        }
    }
    
    // MARK: - View
    public static func view(type: RecordContentType) -> LogWritingView {
        LogWritingView(
            store: Store(
                initialState: LogWritingStore.State(
                    type: type
                )
            ) {
                LogWritingStore()
            }
        )
    }
}


