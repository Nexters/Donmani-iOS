//
//  BottleListStore.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import ComposableArchitecture

@Reducer
struct BottleListStore {
    
    // MARK: - State
    @ObservableState
    struct State {
        var isPresentingTopBanner: Bool
        var isPresendTextGuide: Bool = false
        var rowIndex: Int = 0
        
        var starCount: [Int:Int] = [3:8, 4:0, 5:2, 6:-1, 7:-1, 8:-1, 9:-1, 10:-1, 11:-1, 12:-1]
        var starCountSort: [(Int,Int)] = []
        var endOfDay: [Int: Int] = [:]
        
        init(year: Int = 2025) {
            self.isPresentingTopBanner = HistoryStateManager.shared.getMonthlyBottleGuide()
            self.starCountSort = self.starCount.sorted { $0.key < $1.key }
            self.rowIndex = (starCount.count / 3) + 1
            self.endOfDay = DateManager.shared.generateEndOfDay(year: year)
        }
    }
    
    // MARK: - Action
    enum Action {
        case closeTopBanner
        case showEmptyBottleToast
        case dismissEmptyBottleToast
        case delegate(Delegate)
        enum Delegate {
            case popToPreviousView
            case pushMonthlyBottleView(Int, Int)
        }
    }
    
    // MARK: - Dependency
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTopBanner:
                state.isPresentingTopBanner = false
                HistoryStateManager.shared.setMonthlyBottleGuide()
                return .none
                
            case .showEmptyBottleToast:
                if (state.isPresendTextGuide) {
                    return .none
                }
                state.isPresendTextGuide = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    await send(.dismissEmptyBottleToast, animation: .linear(duration: 0.5)
                    )
                }
                
            case .dismissEmptyBottleToast:
                state.isPresendTextGuide = false
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
