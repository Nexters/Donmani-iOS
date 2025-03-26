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
            StatisticsView()
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
                            RecordIntegrateView(
                                goodRecord: contents[0],
                                badRecord: contents[1]
                            )
                        } else {
                            EmptyRecordView()
                        }
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, .defaultLayoutPadding)
            }
            .padding(.top, .s5)
        }
        .padding(.top, 17)
    }
    
    func StatisticsView() -> some View {
        RoundedRectangle(cornerRadius: .s5, style: .circular)
            .fill(DColor(.deepBlue60).color)
            .frame(height: 156)
            .padding(.horizontal, .defaultLayoutPadding)
    }
}
