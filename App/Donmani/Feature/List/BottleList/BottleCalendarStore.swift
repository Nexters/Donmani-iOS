//
//  BottleCalendarStore.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import ComposableArchitecture

@Reducer
struct BottleCalendarStore {
    
    // MARK: - State
    @ObservableState
    struct State {
        var isPresentingTopBanner: Bool
        var isPresentTextGuide: Bool = false
        
        var starCount: [Int: Int] = [:]
        var starCountSort: [(Int, Int)] = []
        var lastDaysOfMonths: [Int: Int] {
            Day.lastDaysOfMonths(year: Day.today.year)
        }
        
        var toastType: ToastType = .none
        
        init(context: RecordCountSummary) {
            self.isPresentingTopBanner = HistoryStateManager.shared.getMonthlyBottleGuide()
            let today: Day = .today
            for month in (3...12) { // Only in 2025
                self.starCount[month] = context.monthlyRecords[month]?.recordCount ?? -1
                if self.starCount[month, default: -1] == -1 {
                    if month <= today.month {
                        self.starCount[month] = 0
                    }
                }
            }
            self.starCountSort = self.starCount.sorted { $0.key < $1.key }
        }
    }
    
    // MARK: - Action
    enum Action {
        case closeTopBanner
        case showEmptyBottleToast
        case completeShowToast
        
        case fetchMonthlyRecord(Int, Int)
        case delegate(Delegate)
        enum Delegate {
            case pushMonthlyBottleView(Day, [Record], [Reward])
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.recordRepository) var recordRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTopBanner:
                state.isPresentingTopBanner = false
                HistoryStateManager.shared.setMonthlyBottleGuide()
                
            case .showEmptyBottleToast:
                state.toastType = .emptyRecordMonth
                
            case .completeShowToast:
                state.toastType = .none
                
            case .fetchMonthlyRecord(let year, let month):
                return .run { send in
                    let monthlyRecordState = try await recordRepository.getMonthlyRecordList(year: year, month: month)
                    let records = monthlyRecordState.records ?? []
                    recordRepository.saveRecords(records)
                    await send(.delegate(.pushMonthlyBottleView(Day(year: year, month: month), records, monthlyRecordState.saveItems)))
                }
                
            case .delegate:
                break
            }
            return .none
        }
    }
}
