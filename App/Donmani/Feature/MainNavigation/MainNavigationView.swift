//
//  MainNavigationView.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import SwiftUI
import ComposableArchitecture

struct MainNavigationView: View {
    @Bindable var navigationStore: StoreOf<MainNavigationStore>
    
    init(store: StoreOf<MainNavigationStore>) {
        self.navigationStore = store
        UINavigationController.store = self.navigationStore
    }
    
    var body: some View {
        NavigationStack(
            path: $navigationStore.scope(state: \.path, action: \.path)
        ) {
            MainView(store: navigationStore.scope(
                state: \.mainState,
                action: \.mainAction
            ))
        } destination: { store in
            switch store.case {
                // Record
            case .record(let store):
                RecordEntryPointView(store: store) { record in
                    navigationStore.send(.completeWriteRecord(record))
                }
            case .recordWriting(let store):
                RecordWritingView(store: store) { recordContent in
                    navigationStore.send(.completeWriteRecordContent(recordContent))
                }
                
                // List
            case .monthlyRecordList(let store):
                RecordListView(store: store)
            case .bottleCalendar(let store):
                BottleCalendarView(store: store)
            case .statistics(let store):
                StatisticsView(store: store)
            case .monthlyStarBottle(let store):
                MonthlyStarBottleView(store: store)
                
                // Reward
            case .rewardStart(let store):
                RewardStartView(store: store)
            case .rewardReceive(let store):
                RewardReceiveView(store: store)
            case .decoration(let store):
                DecorationView(store: store)
                
            case .setting(let store):
                SettingView(store: store)
            }
        }
        .onChange(of: navigationStore.path.ids) { oldPathIDs, newPathIDs in
            if newPathIDs.count.isZero {
                Task {
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 3)
                    await navigationStore.send(.requestNotificationPermission).finish()
                }
            }
        }
    }
}

#Preview {
    MainNavigationView(
        store: MainStoreFactory().makeMainNavigationStore(
            state: MainStateFactory().makeMainNavigationState(
                mainState: MainStateFactory().makeMainState(
                    context: MainStore.Context(
                        records: [],
                        hasRecord: (today: true, yesterday: false),
//                        decorationItem: [:],
                        isPresentingNewStarBottle: false,
                        decorationData: DecorationData(
                            backgroundRewardData: nil,
                            effectRewardData: nil,
                            decorationRewardName: nil,
                            decorationRewardId: nil,
                            bottleRewardId: nil,
                            bottleShape: .default
                        )
                    )
                )
            )
        )
    )
}
