//
//  MainNavigationView.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import SwiftUI
import ComposableArchitecture

struct MainNavigationView: View {
    @Bindable var store: StoreOf<MainNavigationStore>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            MainView(store: store.scope(
                state: \.mainState,
                action: \.mainAction
            ))
        } destination: { store in
            switch store.case {
            case .record(let store):
                RecordEntryPointView(store: store) { record in
                    print(record)
                }
            case .recordWriting(let store):
                RecordWritingView(store: store) { recordContent in
                    
                }
            case .monthlyRecordList(let store):
                RecordListView(store: store)
            case .bottleCalendar(let store):
                BottleCalendarView(store: store)
            case .statistics(let store):
                StatisticsView(store: store)
            case .monthlyStarBottle(let store):
                MonthlyStarBottleView(store: store)
            case .setting:
                SettingView()
            }
        }
    }
}

#Preview {
    {
        let state = MainStateFactory().makeMainNavigationState()
        let store = MainStoreFactory().makeMainNavigationStore(state: state)
        return MainNavigationView(store: store)
    }()
}
