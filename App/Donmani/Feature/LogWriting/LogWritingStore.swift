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
        enum LogType {
            case good
            case bad
            
            var title: String {
                switch self {
                case .good:
                    return "행복 소비"
                case .bad:
                    return "후회 소비"
                }
            }
        }
        
        var category: [LogCategory] {
            switch self.type {
            case .good:
                return GoodCategory.allCases.map { LogCategory($0) }
            case .bad:
                return BadCategory.allCases.map { LogCategory($0) }
            }
        }
        
        var sticker: Image {
            switch self.type {
            case .good:
                return DImage(.defaultGoodSticker).image
            case .bad:
                return DImage(.defaultGoodSticker).image
            }
        }
        
        var type: LogType
        var selectedCategory: LogCategory?
        var text: String = ""
        
        init(type: LogType, selectedCategory: LogCategory? = nil) {
            self.type = type
            self.selectedCategory = selectedCategory
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case touchCategory
        case selectCategory(LogCategory)
//        case write(String)
        case binding(BindingAction<State>)
        case save
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .touchCategory:
                return .none
            case .selectCategory(let category):
                print(category)
                return .none
//            case .write(let content):
//                print(content)
//                return .none
            case .binding(let state):
                print(state)
                return .none
            case .save:
                return .none
            }
        }
    }
    
    // MARK: - View
    public static func view(type: State.LogType = .good) -> LogWritingView {
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


