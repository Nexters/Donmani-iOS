//
//  MainNavigationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import ComposableArchitecture

@Reducer
struct MainNavigationStore {
    
    @ObservableState
    struct State {
        var mainState: MainStore.State
        var path = StackState<MainNavigationStore.Path.State>()
        
        init() {
            self.mainState = MainStore.State()
        }
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case path(StackActionOf<MainNavigationStore.Path>)
        
        case push(Destination)
        enum Destination {
            case monthlyRecordList(Int, Int, Bool)
            case bottleCalendar(RecordCountSummary)
            case statistics(Int, Int)
            case monthlyStarBottle(Int, Int)
        }
    }
    
    @Dependency(\.mainStateFactory) var stateFactory
    
    var body: some ReducerOf<Self> {
        Scope(
            state: \.mainState,
            action: \.mainAction
        ) {
            MainStore()
        }
        
        Reduce { state, action in
            switch action {
            case .mainAction(let mainAction):
                switch mainAction {
                case .delegate(let action):
                    return runMainAction(action, &state)
                default: break
                }
            case .path(let element):
                return path(element: element, &state)
                
            case .push(let destination):
                return push(to: destination, &state)
            }
            
            return .none
        }
        .forEach(\.path, action: \.path)
    }
}

extension MainNavigationStore {
    @Reducer
    enum Path {
        case monthlyRecordList(RecordListStore)
        case bottleCalendar(BottleListStore)
        case statistics(StatisticsStore)
        case monthlyStarBottle(MonthlyStarBottleStore)
        case setting
    }
}
