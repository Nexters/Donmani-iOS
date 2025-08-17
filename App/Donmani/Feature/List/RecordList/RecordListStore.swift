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
        let day: Day
        let records: [Record]
        let isShowNavigationButton: Bool
        init(day: Day, records: [Record], _ isShowNavigationButton: Bool = true) {
            self.day = day
            self.records = records
            self.isShowNavigationButton = isShowNavigationButton
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let records: [Record]
        let day: Day
        let isShowNavigationButton: Bool
        let goodCount: Int
        let badCount: Int
        let progressPoint: CGFloat
        var isPresentingBottleCalendarToolTipView: Bool = false
        var dateSet: Set<Day>
        
        init(context: Context) {
            self.records = context.records
            self.day = context.day
            
            let count = self.records.reduce(into: (goodCount: 0, badCount: 0)) { count, item in
                count.goodCount += (item.records[.good].isSome ? 1 : 0)
                count.badCount += (item.records[.bad].isSome ? 1 : 0)
            }
            self.goodCount = count.goodCount
            self.badCount = count.badCount
            self.isShowNavigationButton = context.isShowNavigationButton
            if (count.0 + count.1) > 0 {
                self.progressPoint = CGFloat(count.0) / CGFloat(count.0 + count.1)
            } else {
                self.progressPoint = -1
            }
            self.isPresentingBottleCalendarToolTipView = (HistoryStateManager.shared.getIsShownBottleCalendarToopTip() == nil)
            self.dateSet = []
        }
    }
    
    // MARK: - Action
    enum Action {
        case closeBottleCalendarToolTip
        case touchStatisticsView(Bool)
        case pushStatisticsView
        case pushBottleCalendarView
        case addAppearCardView(Day?)
        
        case delegate(Delegate)
        enum Delegate {
            case pushBottleCalendarView(RecordCountSummary)
            case pushRecordEntryPointView
            case pushStatisticsView(Int, Int)
        }
    }
    
    
    // MARK: - Dependency
    @Dependency(\.recordRepository) var recordRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeBottleCalendarToolTip:
                state.isPresentingBottleCalendarToolTipView = false
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
                let year = state.day.year
                let month = state.day.month
                return .run { send in
                    await send(.delegate(.pushStatisticsView(year, month)))
                }
            
            case .pushBottleCalendarView:
                GA.Click(event: .listButton).send()
                return .run { send in
                    let result = try await recordRepository.getYearlyRecordSummary(year: 2025)
                    await send(.delegate(.pushBottleCalendarView(result)))
                }
                
            case .addAppearCardView(let day):
                if let day {
                    state.dateSet.insert(day)
                } else {
                    //
                }

            case .delegate(.pushBottleCalendarView(_)):
                state.isPresentingBottleCalendarToolTipView = false
                HistoryStateManager.shared.setIsShownBottleCalendarToopTip()
            case .delegate:
                break
            }
            return .none
        }
    }
}
