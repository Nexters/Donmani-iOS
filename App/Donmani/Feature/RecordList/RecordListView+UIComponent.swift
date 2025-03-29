//
//  RecordListView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//


import SwiftUI
import DesignSystem

extension RecordListView {
    
    func EmptyGuideView() -> some View {
        ZStack {
            VStack(spacing: .s5) {
                Spacer()
                Text("아직 기록이 없어요")
                    .font(DFont.font(.h2, weight: .semibold))
                    .foregroundStyle(DColor(.gray95).color)
                DButton(title: "기록하기", isEnabled: true) {
                    store.send(.delegate(.pushRecordEntryPointView))
                }
                .frame(width: 100)
                Spacer()
            }
        }
    }
    
    func RecordScrollView() -> some View {
        ScrollView {
            SimpleStatisticsView()
                .onTapGesture {
                    store.send(.delegate(.pushStatisticsView(store.yearMonth.year, store.yearMonth.month)))
                }
            LazyVStack {
                ForEach(store.record, id: \.date) { record in
                    VStack {
                        HStack {
                            Text(convertDateTitle(record.date) ?? "")
                                .font(DFont.font(.b2, weight: .medium))
                                .foregroundStyle(DColor(.gray95).color)
                            Spacer()
                        }
                        if let contents = record.contents {
                            if contents.count > 1 {
                                RecordIntegrateView(
                                    goodRecord: contents[0],
                                    badRecord: contents[1]
                                )
                            } else {
                                RecordView(
                                    record: contents[0],
                                    isEditable: false
                                )
                            }
                            
                        } else {
                            EmptyRecordView()
                        }
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, .defaultLayoutPadding)
            }
            .padding(.top, 40)
        }
        .padding(.top, 17)
    }
    
    func SimpleStatisticsView() -> some View {
        RoundedRectangle(cornerRadius: .s5, style: .circular)
            .fill(DColor(.deepBlue60).color)
            .frame(height: 156)
            .overlay {
                VStack(alignment: .leading, spacing: .s5)  {
                    HStack {
                        Text("\(store.yearMonth.year)월 기록 통계")
                            .font(DFont.font(.b1, weight: .semibold))
                            .foregroundStyle(DColor(.gray99).color)
                        DImage(.rightArrow).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s5, height: .s5)
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
                    
                    VStack(spacing: 4) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(DColor(.pupleBlue70).color)
                                .frame(width: 6, height: 6)
                            Text("행복 \(store.goodCount)개")
                                .font(DFont.font(.b2, weight: .medium))
                                .foregroundStyle(DColor(.deepBlue99).color)
                        }
                        HStack(spacing: 8) {
                            Circle()
                                .fill(DColor(.pupleBlue99).color)
                                .frame(width: 6, height: 6)
                            Text("후회 \(store.badCount)개")
                                .font(DFont.font(.b2, weight: .medium))
                                .foregroundStyle(DColor(.deepBlue99).color)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .padding(.s5)
            }
            .padding(.horizontal, .defaultLayoutPadding)
    }
}
