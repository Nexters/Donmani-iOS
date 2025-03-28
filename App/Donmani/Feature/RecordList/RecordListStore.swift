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
        
        init(
            year: Int,
            month: Int,
            isShowNavigationButton: Bool
        ) {
            self.yearMonth = (year % 100, month)
            let monthString = String(format: "%02d", month)
            self.record = (DataStorage.getRecord(yearMonth: "\(year)-\(monthString)") ?? []).sorted {
                $0.date > $1.date
            }
            let count = self.record.reduce(into: (0,0)) { count, item in
                if let contents = item.contents {
                    for c in contents {
                        if c.flag == .good {
                            count.0 += 1
                        } else {
                            count.1 += 1
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
                self.progressPoint = 0.0
            }
            
        }
        
        init() {
            let yearMonth = DateManager.shared.getFormattedDate(
                for: .today, .yearMonth
            ).components(separatedBy: "-")
            self.yearMonth = (Int(yearMonth[0])! % 100, Int(yearMonth[1])!)
            self.record = (DataStorage.getRecord(yearMonth: "\(yearMonth[0])-\(yearMonth[1])") ?? []).sorted {
                $0.date > $1.date
            }
            isShowNavigationButton = true
            let count = self.record.reduce(into: (0,0)) { count, item in
                if let contents = item.contents {
                    for c in contents {
                        if c.flag == .good {
                            count.1 += 1
                        } else {
                            count.0 += 1
                        }
                    }
                }
            }
            self.goodCount = count.0
            self.badCount = count.1
            if (count.0 + count.1) > 0 {
                self.progressPoint = CGFloat(count.0) / CGFloat(count.0 + count.1)
            } else {
                self.progressPoint = 0.0
            }
        }
    }
    
    // MARK: - Action
    enum Action {
        case delegate(Delegate)
        enum Delegate {
            case pushBottleListView
            case pushRecordEntryPointView
            case pushStatisticsView(Int, Int)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
}
