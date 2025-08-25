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

    struct Context {
        let day: Day
        let records: [Record]
        init(day: Day, records: [Record]) {
            self.day = day
            self.records = records
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let day: Day
        let records: [Record]

        var recordRatio: [RecordCategory: CGFloat] = [:]
        var goodTotalCount: Int = 0
        var badTotalCount: Int = 0
        var isPresentingProposeFunctionView = false
        
        init(context: Context) {
            self.day = context.day
            self.records = context.records
            var goodRecordCount: [RecordCategory: Int] = [:]
            var badRecordCount: [RecordCategory: Int] = [:]
            let count = self.records.reduce(into: (goodCount: 0, badCount: 0)) { count, item in
                if let goodRecord = item.records[.good] {
                    goodRecordCount[goodRecord.category, default: 0] += 1
                    count.goodCount += 1
                }
                
                if let badRecord = item.records[.bad]{
                    badRecordCount[badRecord.category, default: 0] += 1
                    count.badCount += 1
                }
            }
            self.goodTotalCount = count.goodCount
            self.badTotalCount = count.badCount
            
            for item in goodRecordCount {
                recordRatio[item.key] = CGFloat(item.value) / CGFloat(goodTotalCount)
            }
            
            for item in badRecordCount {
                recordRatio[item.key] = CGFloat(item.value) / CGFloat(badTotalCount)
            }
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
