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
        
        var starCount: [Int:Int] = [:]
        var starCountSort: [(Int,Int)] = []
        var endOfDay: [Int: Int] = [:]
        
        init(starCount: [String: SummaryMonthly]) {
            self.isPresentingTopBanner = HistoryStateManager.shared.getMonthlyBottleGuide()
            self.rowIndex = (starCount.count / 3) + 1
            let dateManager = DateManager.shared
            let todayMonth = dateManager.getFormattedDate(for: .today, .yearMonth).components(separatedBy: "-").last ?? "0"
            
            for month in (3...12) {
                self.starCount[month] = starCount["\(month)"]?.recordCount ?? -1
                if self.starCount[month, default: -1] == -1 {
                    if month <= Int(todayMonth) ?? 1 {
                        self.starCount[month] = 0
                    }
                }
            }
            self.endOfDay = dateManager.generateEndOfDay(year: 2025)
            self.starCountSort = self.starCount.sorted { $0.key < $1.key }
        }
    }
    
    // MARK: - Action
    enum Action {
        case closeTopBanner
        case showEmptyBottleToast
        case dismissEmptyBottleToast
        case fetchMonthlyRecord(Int, Int)
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
                
            case .fetchMonthlyRecord(let year, let month):
                return .run { send in
                    let key = "2025-\(String(format: "%02d", month))"
                    if DataStorage.getRecord(yearMonth: key) == nil {
                        let result = try await NetworkService.DRecord().fetchRecordList(year: year, month: month)
                        DataStorage.setMonthRecords(year: year, month: month, result)
                    }
                    await send(.delegate(.pushMonthlyBottleView(year, month)))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
