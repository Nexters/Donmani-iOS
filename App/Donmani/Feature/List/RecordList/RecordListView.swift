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
            BackgroundView()
            VStack(alignment: .center, spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Spacer()
                        DText("\(store.yearMonth.year)년 \(store.yearMonth.month)월 기록")
                            .style(.b1, .semibold, .white)
                        Spacer()
                    }
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                        Spacer()
                        if store.isShowNavigationButton {
                            DNavigationBarButton(.bottleIcon) {
                                store.send(.pushBottleCalendarView)
                            }
                        }
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                if store.record.isEmpty {
                    ZStack {
                        VStack {
                            SimpleStatisticsView()
                                .padding(.top, .s5)
                                .onTapGesture {
                                    store.send(.touchStatisticsView(true))
                                }
                            Spacer()
                        }
                        EmptyGuideView()
                    }
                } else {
                    RecordScrollView()
                }
            }
            
            if store.isPresentingBottleCalendarToopTipView {
                BottleCalendarToopTipView()
            }
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            GA.View(event: .recordhistory).send()
        }
        .onDisappear {
            if store.record.count > 0 {
                let id = store.dateSet.count - 1
                DispatchQueue.global().async {
                    GA.Impression(event: .recordhistory).send(parameters: [.recordID: id])
                }
            }
        }
    }
    
    func convertDateTitle(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let koreanFormatter = DateFormatter()
        koreanFormatter.dateFormat = "M월 d일 EEE요일"
        koreanFormatter.locale = Locale(identifier: "ko_KR")
        
        return koreanFormatter.string(from: date)
    }
}

#Preview {
    {
        let context = RecordListStore.Context(year: 2025, month: 4, false)
        let state = MainStateFactory().makeMonthlyRecordListState(context: context)
        let store = MainStoreFactory().makeMonthlyRecordListStore(state: state)
        return RecordListView(store: store)
    }()
}
