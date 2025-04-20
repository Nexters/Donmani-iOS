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
    
    // MARK: - State
    @ObservableState
    struct State {
        let record: [Record]
        let yearMonth: (year: Int, month: Int)
        let isShowNavigationButton: Bool
        let goodCount: Int
        let badCount: Int
        let progressPoint: CGFloat
        var isPresentingBottleListToopTipView: Bool = false
        
        init(
            year: Int,
            month: Int,
            isShowNavigationButton: Bool
        ) {
            self.yearMonth = (year % 100, month)
            let key = "\(year)-\(String(format: "%02d", month))"
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
            self.isShowNavigationButton = isShowNavigationButton
            if (count.0 + count.1) > 0 {
                self.progressPoint = CGFloat(count.0) / CGFloat(count.0 + count.1)
            } else {
                self.progressPoint = -1
            }
            self.isPresentingBottleListToopTipView = (HistoryStateManager.shared.getIsShownBottleListToopTip() == nil)
            
        }
    }
    
    // MARK: - Action
    enum Action {
        case closeBottleListToopTip
        case delegate(Delegate)
        enum Delegate {
            case pushBottleListView(RecordCountSummary)
            case pushRecordEntryPointView
            case pushStatisticsView(Int, Int)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeBottleListToopTip:
                state.isPresentingBottleListToopTipView = false
                HistoryStateManager.shared.setIsShownBottleListToopTip()
                return .none
            case .delegate(.pushBottleListView(_)):
                state.isPresentingBottleListToopTipView = false
                HistoryStateManager.shared.setIsShownBottleListToopTip()
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
