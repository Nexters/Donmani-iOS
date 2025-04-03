//
//  StatisticsStore.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StatisticsStore {
    
    // MARK: - State
    @ObservableState
    struct State {
        var goodRecord: [GoodCategory: Int] = [:]
        var goodRecordRatio: [GoodCategory: CGFloat] = [:]
        var goodTotalCount: Int = 0
        
        var badRecord: [BadCategory: Int] = [:]
        var badRecordRatio: [BadCategory: CGFloat] = [:]
        var badTotalCount: Int = 0
        
        let yearMonth: (year: Int, month: Int)
        var records: [Record]
        
        var isPresentingProposeFunctionView = false
        
        var sortedGoodRecordIndex: [GoodCategory] {
            let allCases = GoodCategory.allCases
            return (0..<9).sorted { i, j in
                if goodRecord[allCases[i], default: 0] == goodRecord[allCases[j], default: 0] {
                    return i < j
                }
                return goodRecord[allCases[i], default: 0] > goodRecord[allCases[j], default: 0]
            }.map {
                allCases[$0]
            }
        }
        
        var sortedBadRecordIndex: [BadCategory] {
            let allCases = BadCategory.allCases
            return (0..<9).sorted { i, j in
                if badRecord[allCases[i], default: 0] == badRecord[allCases[j], default: 0] {
                    return i < j
                }
                return badRecord[allCases[i], default: 0] > badRecord[allCases[j], default: 0]
            }.map {
                allCases[$0]
            }
        }
        
        init(year: Int, month: Int) {
            self.yearMonth = (year % 100, month)
            let key = "\(year + 2000)-\(String(format: "%02d", month))"
            self.records = (DataStorage.getRecord(yearMonth: key) ?? [])
            for record in records {
                if let contents = record.contents {
                    for content in contents {
                        if content.flag == .good {
                            if let c: GoodCategory = content.category.getInstance() {
                                if c == .none {
                                    continue
                                }
                                self.goodTotalCount += 1
                                self.goodRecord[c, default: 0] += 1
                            }
                        } else {
                            if let c: BadCategory = content.category.getInstance() {
                                if c == .none {
                                    continue
                                }
                                self.badTotalCount += 1
                                self.badRecord[c, default: 0] += 1
                            }
                        }
                    }
                }
            }
            for item in goodRecord {
                goodRecordRatio[item.key] = CGFloat(item.value) / CGFloat(goodTotalCount)
            }
            
            for item in badRecord {
                badRecordRatio[item.key] = CGFloat(item.value) / CGFloat(badTotalCount)
            }
            print(goodRecordRatio)
            print(badRecordRatio)
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case touchProposeFunction
        case binding(BindingAction<State>)
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchProposeFunction:
                state.isPresentingProposeFunctionView.toggle()
                return .none
            case .binding:
                return .none
            }
        }
    }
}
