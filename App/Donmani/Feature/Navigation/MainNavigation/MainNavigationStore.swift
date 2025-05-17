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
            let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
            self.mainState = MainStore.State(today: today)
        }
    }
    
    enum Action {
        case mainAction(MainStore.Action)
        case path(StackActionOf<MainNavigationStore.Path>)
        
        case push(Destination)
        enum Destination {
            case record
            case recordWriting(RecordContentType, RecordContent?)
            case monthlyRecordList(Int, Int, Bool)
            case bottleCalendar(RecordCountSummary)
            case statistics(Int, Int)
            case monthlyStarBottle(Int, Int)
            // case setting
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
            case .mainAction(.delegate(let mainAction)):
                switch mainAction {
                case .pushSettingView:
                    state.path.append(.setting)
                case .pushRecordEntryPointView:
                    return .run { send in
                        await send(.push(.record))
                    }
                case .pushRecordListView:
                    return .run { send in
                        let dateManager = DateManager.shared
                        let dayString = dateManager.getFormattedDate(for: .today)
                        let day = Day(yyyymmdd: dayString)
                        await send(.push(.monthlyRecordList(day.year, day.month, true)))
                    }
                case .pushBottleCalendarView(let recordCountSummary):
                    return .run { send in
                        await send(.push(.bottleCalendar(recordCountSummary)))
                    }
                }
                
            case .path(.element(let id, let action)):
                return path(id: id, action: action, &state)
                
            case .push(let destination):
                return push(to: destination, &state)
                
            default:
                break;
            }
            return .none
        }
        .forEach(\.path, action: \.path)
    }
}

extension MainNavigationStore {
    @Reducer
    enum Path {
        case record(RecordEntryPointStore)
        case recordWriting(RecordWritingStore)
        case monthlyRecordList(RecordListStore)
        case bottleCalendar(BottleCalendarStore)
        case statistics(StatisticsStore)
        case monthlyStarBottle(MonthlyStarBottleStore)
        case setting
    }
}
