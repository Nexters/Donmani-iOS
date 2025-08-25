//
//  AppStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import UIKit
import ComposableArchitecture

@Reducer
struct RootStore {
    @Dependency(\.mainStoreFactory) var storeFactory
    @Dependency(\.mainStateFactory) var stateFactory
    @Dependency(\.recordRepository) var recordRepository
    
    var today: Day {
        .today
    }
    
    enum MainRoute {
        case main
        case record
    }
    
    enum AppRoute: Equatable {
        case splash
        case onboarding
        case main(StoreOf<MainNavigationStore>)
        
        var id: String {
            switch self {
            case .splash:       "splash"
            case .onboarding:   "onboarding"
            case .main(_):      "main"
            }
        }
    }
    
    @ObservableState
    struct State {
        var route: AppRoute = .splash
    }
    
    enum Action {
        case completeSplash
        case completeOnboarding(MainRoute)
        
        case presentRecordEntryPointView
        case presentMainView(StoreOf<MainNavigationStore>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .completeSplash:
                if HistoryStateManager.shared.getOnboardingState() {
                    state.route = .onboarding
                } else {
                    return .run { send in
                        await send(.completeOnboarding(.main))
                    }
                }
                
            case .completeOnboarding(let mainRoute):
                return .run { @MainActor send in
                    UINavigationController.isBlockSwipe = false
                    if mainRoute == .record {
                        send(.presentRecordEntryPointView)
                        return
                    }
                    
                    let day: Day = .today
                    let monthlyRecordState = try await recordRepository.getMonthlyRecordList(year: day.year, month: day.month)
                    let hasTodayRecord = recordRepository.load(date: .today).isSome
                    let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                    
                    let mainContext = MainStore.Context(
                        records: monthlyRecordState.records ?? [],
                        hasRecord: (hasTodayRecord, hasYesterdayRecord),
                        decorationItem: monthlyRecordState.decorationItem
                    )
                    let mainState = stateFactory.makeMainState(context: mainContext)
                    let mainNavigationState = stateFactory.makeMainNavigationState(mainState: mainState)
                    let mainNavigationStore = storeFactory.makeMainNavigationStore(state: mainNavigationState)
                    send(.presentMainView(mainNavigationStore))
                    
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond)
                    await NotificationManager().checkNotificationPermission()
                }
                
            case .presentRecordEntryPointView:
                return .run { @MainActor send in
                    let day: Day = .today
                    let monthlyRecordState = try await recordRepository.getMonthlyRecordList(year: day.year, month: day.month)
                    let hasTodayRecord = recordRepository.load(date: .today).isSome
                    let hasYesterdayRecord = recordRepository.load(date: .yesterday).isSome
                    
                    let mainContext = MainStore.Context(
                        records: monthlyRecordState.records ?? [],
                        hasRecord: (hasTodayRecord, hasYesterdayRecord),
                        decorationItem: monthlyRecordState.decorationItem
                    )
                    let mainState = stateFactory.makeMainState(context: mainContext)
                    var mainNavigationState = stateFactory.makeMainNavigationState(mainState: mainState)
                    
                    if !(hasTodayRecord && hasYesterdayRecord) {
                        let context = RecordEntryPointStore.Context(
                            today: hasTodayRecord,
                            yesterday: hasYesterdayRecord
                        )
                        let recordEntryPointState = stateFactory.makeRecordEntryPointState(context: context)
                        mainNavigationState.path.append(.record(recordEntryPointState))
                        mainNavigationState.mainState.starBottleOpacity = 0.0
                    } else {
                        mainNavigationState.mainState.isPresentingAlreadyWrite = true
                    }
                    let mainNavigationStore = storeFactory.makeMainNavigationStore(state: mainNavigationState)
                    send(.presentMainView(mainNavigationStore))
                }
                
                
            case .presentMainView(let store):
                state.route = .main(store)
            }
            
            return .none
        }
    }
}
