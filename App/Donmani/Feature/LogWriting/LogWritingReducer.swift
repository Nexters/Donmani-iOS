//
//  LogWritingReducer.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem


@Reducer
struct LogWritingReducer {
    
    // MARK: - State
    @ObservableState
    struct LogWritingState: Equatable {
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
        
        var category: [Category] {
            switch self.type {
            case .good:
                return GoodCategory.allCases.map { Category($0) }
            case .bad:
                return BadCategory.allCases.map { Category($0) }
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
        var selectedCategory: Category?
        var text: String
        
        init(type: LogType, selectedCategory: Category? = nil, text: String = "") {
            self.type = type
            self.selectedCategory = selectedCategory
            self.text = text
        }
    }
    
    // MARK: - Action
    enum LogWritingAction: Equatable {
        case touchCategory
        case selectCategory(Category)
        case write(String)
        case save
    }
    
    // MARK: - Reducer
    var body: some Reducer<LogWritingState, LogWritingAction> {
        Reduce { state, action in
            switch action {
            case .touchCategory:
                return .none
            case .selectCategory(let category):
                return .none
            case .write(let content):
                state.text = content
                return .none
            case .save:
                return .none
            }
        }
    }
}
