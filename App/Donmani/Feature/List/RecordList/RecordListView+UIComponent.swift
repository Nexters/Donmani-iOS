//
//  RecordListView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//


import SwiftUI
import DesignSystem
import ComposableArchitecture

extension RecordListView {
    struct BottleCalendarToolTipView: View {
        @Bindable var store: StoreOf<RecordListStore>
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Triangle(direction: .up)
                        .fill(DColor(.deepBlue80).color)
                        .frame(width: 14, height: 8)
                        .padding(.trailing, 12)
                }
                HStack {
                    Spacer()
                    HStack {
                        DText("별통이만 모아볼 수 있어요!")
                            .style(.b3, .semibold, .white)
                        Button {
                            store.send(.closeBottleCalendarToolTip)
                        } label: {
                            DImage(.close).image
                                .resizable()
                                .frame(width: .s5, height: .s5)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(DColor(.deepBlue80).color)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                Spacer()
            }
            .padding(.top, 42)
            .padding(.horizontal, 13)
        }
    }
    
    struct EmptyGuideView: View {
        @Bindable var store: StoreOf<RecordListStore>
        
        var body: some View {
            ZStack {
                VStack(spacing: .s5) {
                    Spacer()
                    DText("아직 기록이 없어요")
                        .style(.h2, .semibold, .gray95)
                    DButton(title: "기록하기", isEnabled: true) {
                        store.send(.delegate(.pushRecordEntryPointView))
                    }
                    .frame(width: 100)
                    Spacer()
                }
            }
        }
    }
    
    struct RecordScrollView: View {
        @Bindable var store: StoreOf<RecordListStore>
        
        var body: some View {
            ScrollView {
                SimpleStatisticsView(store: store)
                    .onTapGesture {
                        store.send(.touchStatisticsView(false))
                    }
                LazyVStack {
                    ForEach(store.records, id: \.day.day) { record in
                        VStack {
                            HStack {
                                DText(record.day.dateString)
                                    .style(.b2, .medium, .gray95)
                                Spacer()
                            }
                            if record.records.isEmpty {
                                EmptyRecordView()
                            } else {
                                RecordCardView(
                                    goodRecord: record.records[.good],
                                    badRecord: record.records[.bad]
                                )
                                .onAppear {
                                    print(record.day)
                                }
                            }
                        }
                        .onAppear {
                            store.send(.addAppearCardView(record.day))
                        }
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal, .defaultLayoutPadding)
                    Spacer()
                        .frame(height: 0.5)
                        .onAppear {
                            store.send(.addAppearCardView(nil))
                        }
                }
                .padding(.top, 40)
            }
            .padding(.top, 17)
        }
    }
    
    struct SimpleStatisticsView: View {
        @Bindable var store: StoreOf<RecordListStore>
        
        var body: some View {
            RoundedRectangle(cornerRadius: .s5, style: .circular)
                .fill(DColor(.deepBlue60).color)
                .frame(height: 156)
                .overlay {
                    VStack(alignment: .leading, spacing: .s5)  {
                        HStack {
                            DText("\(store.day.month)월 기록 통계")
                                .style(.b1, .semibold, .gray99)
                            if store.progressPoint > -1 {
                                DImage(.rightArrow).image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: .s5, height: .s5)
                            }
                        }
                        
                        if store.progressPoint == -1 {
                            Capsule()
                                .fill(DColor(.deepBlue80).color)
                                .frame(height: .s4)
                        } else {
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: DColor(.pupleBlue70).color, location: store.progressPoint),
                                            .init(color: DColor(.pupleBlue99).color, location: store.progressPoint)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: .s4)
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(DColor(.pupleBlue70).color)
                                    .frame(width: 6, height: 6)
                                DText("행복 \(store.goodCount)개")
                                    .style(.b2, .medium, .deepBlue99)
                            }
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(DColor(.pupleBlue99).color)
                                    .frame(width: 6, height: 6)
                                DText("후회 \(store.badCount)개")
                                    .style(.b2, .medium, .deepBlue99)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(.s5)
                }
                .padding(.horizontal, .defaultLayoutPadding)
        }
    }
}
