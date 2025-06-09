//
//  RecordListStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RecordListStore {
    struct Context {
        let year: Int
        let month: Int
        let isShowNavigationButton: Bool
        init(year: Int, month: Int, _ isShowNavigationButton: Bool = true) {
            self.year = year
            self.month = month
            self.isShowNavigationButton = isShowNavigationButton
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let record: [Record]
        let yearMonth: (year: Int, month: Int)
        let isShowNavigationButton: Bool
        let goodCount: Int
        let badCount: Int
        let progressPoint: CGFloat
        var isPresentingBottleCalendarToopTipView: Bool = false
        var dateSet: Set<String>
        
        init(context: Context) {
            self.yearMonth = (context.year % 100, context.month)
            let key = "\(context.year)-\(String(format: "%02d", context.month))"
            self.record = (DataStorage.getRecord(yearMonth: key) ?? []).sorted {
                $0.date > $1.date
            }
            let count = self.record.reduce(into: (0,0)) { count, item in
                if let contents = item.contents {
                    for c in contents {
                        if c.flag == .good {
                            if let c: GoodCategory = c.category.getInstance() {
                                if c == .none {
                                    continue
                                }
                                count.0 += 1
                            }
                        } else {
                            if let c: BadCategory = c.category.getInstance() {
                                if c == .none {
                                    continue
                                }
                                count.1 += 1
                            }
                        }
                    }
                }
            }
            self.goodCount = count.0
            self.badCount = count.1
            self.isShowNavigationButton = context.isShowNavigationButton
            if (count.0 + count.1) > 0 {
                self.progressPoint = CGFloat(count.0) / CGFloat(count.0 + count.1)
            } else {
                self.progressPoint = -1
            }
            self.isPresentingBottleCalendarToopTipView = (HistoryStateManager.shared.getIsShownBottleCalendarToopTip() == nil)
            self.dateSet = []
        }
    }
    
    // MARK: - Action
    enum Action {
        case closeBottleCalendarToopTip
        case touchStatisticsView(Bool)
        case pushStatisticsView
        case pushBottleCalendarView
        case addAppearCardView(String)
        
        case delegate(Delegate)
        enum Delegate {
            case pushBottleCalendarView(RecordCountSummary)
            case pushRecordEntryPointView
            case pushStatisticsView(Int, Int)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeBottleCalendarToopTip:
                state.isPresentingBottleCalendarToopTipView = false
                HistoryStateManager.shared.setIsShownBottleCalendarToopTip()
            case .touchStatisticsView(let isEmpty):
                let value = isEmpty ? "no_record" : "has_record"
                GA.Click(event: .insightButton).send(parameters: [.recordStatus: value])
                if !isEmpty {
                    return .run { send in
                        await send(.pushStatisticsView)
                    }
                }
            case .pushStatisticsView:
                let year = state.yearMonth.year
                let month = state.yearMonth.month
                return .run { send in
                    await send(.delegate(.pushStatisticsView(year, month)))
                }
            
            case .pushBottleCalendarView:
                GA.Click(event: .listButton).send()
                return .run { send in
                    let response = try await NetworkService.DRecord().fetchMonthlyRecordCount(year: 2025)
                    let result = NetworkDTOMapper.mapper(dto: response)
                    await send(.delegate(.pushBottleCalendarView(result)))
                }
                
            case .addAppearCardView(let date):
                state.dateSet.insert(date)

            case .delegate(.pushBottleCalendarView(_)):
                state.isPresentingBottleCalendarToopTipView = false
                HistoryStateManager.shared.setIsShownBottleCalendarToopTip()
            case .delegate:
                break
            }
            return .none
        }
    }
}
