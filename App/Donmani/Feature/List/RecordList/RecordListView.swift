//
//  RecordListView.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct RecordListView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<RecordListStore>
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                DNavigationBar(
                    leading: {
                        DNavigationBarButton(.arrowLeft) {
                            dismiss()
                        }
                    },
                    title: {
                        DText("\(store.day.year)년 \(store.day.month)월 기록")
                            .style(.b1, .semibold, .white)
                    },
                    trailing: {
                        if store.isShowBottleCalendarNavigationButton {
                            DNavigationBarButton(.bottle) {
                                store.send(.pushBottleCalendarView)
                            }
                        }
                    }
                )
                
                if store.records.isEmpty {
                    ZStack {
                        VStack {
                            SimpleStatisticsView(store: store)
                                .padding(.top, .s5)
                                .onTapGesture {
                                    store.send(.touchStatisticsView(true))
                                }
                            Spacer()
                        }
                        EmptyGuideView(store: store)
                    }
                } else {
                    RecordScrollView(store: store)
                }
            }
            
            if store.isPresentingBottleCalendarToolTipView {
                BottleCalendarToolTipView(store: store)
            }
            
        }
        .navigationBarBackButtonHidden()
        .background {
            BackgroundView()
        }
        .onAppear {
            GA.View(event: .recordhistory).send()
        }
        .onDisappear {
            if store.records.count > 0 {
                let id = store.dateSet.count - 1
                DispatchQueue.global().async {
                    GA.Impression(event: .recordhistory).send(parameters: [.recordID: id])
                }
            }
        }
    }
}

#Preview {
    {
        let context = RecordListStore.Context(day: .today, records: [], false)
        let state = MainStateFactory().makeMonthlyRecordListState(context: context)
        let store = MainStoreFactory().makeMonthlyRecordListStore(state: state)
        return RecordListView(store: store)
    }()
}
