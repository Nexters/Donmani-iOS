//
//  BottleListView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import DesignSystem

extension BottleListView {
    func TopBannerView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .s5, style: .circular)
                .fill(DColor(.deepBlue60).color)
                .frame(height: 56)
            HStack(alignment: .center, spacing: 8) {
                DImage(.notice).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
                DText("매 월 1일에 새로운 별통이가 열려요")
                    .style(.b1, .regular, .gray95)
                Spacer()
                
                Button {
                    store.send(.closeTopBanner)
                } label: {
                    DImage(.close).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .s4, height: .s4)
                }
            }
            .padding(.s5)
        }
        .padding(.horizontal, .defaultLayoutPadding)
        .padding(.top, .s5)
    }
    
    func MonthlyBottleGridView() -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(minimum: 0)), count: 3),
            spacing: .s3
        ) {
            ForEach(store.starCountSort, id: \.0) { month in
                HStack {
                    Spacer()
                    MonthlyBottleView(
                        month: month.0,
                        count: month.1
                    )
                    .onTapGesture {
                        GA.Click(event: .list별통이Button).send(parameters: [.별통이ID: 2500 + month.0])
                        if (month.1 == 0) {
                            store.send(.showEmptyBottleToast)
                        } else {//if month.1 != -1 {
                            store.send(.fetchMonthlyRecord(2025, month.0))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    func MonthlyBottleView(
        month: Int,
        count: Int
    ) -> some View {
        VStack(alignment: .center, spacing: 4) {
            if (count == -1) {
                DImage(.miniLockedBottle).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 116)
            } else {
                ZStack {
                    DImage(.miniOpenedBottle).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack(spacing: 4) {
                        DImage(.smallStar).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s4, height: .s4)
                        HStack(alignment: .bottom,spacing: 0) {
                            DText("\(count)")
                                .style(.b2, .semibold, .gray80)
                            DText("/\(store.endOfDay[month, default: 0])")
                                .style(.b3, .semibold, .deepBlue80)
                        }
                    }
                    .padding(.top, 6)
                }
                .frame(height: 116)
            }
            
            DText("\(month)월")
                .style(.b2, .semibold, (count > -1) ? .gray99 : .deepBlue80)
        }
    }
    
    func TextGuideView() -> some View {
        HStack(spacing: 8) {
            DImage(.warning).image
                .resizable()
                .frame(width: .s3, height: .s3)
            DText("앗! 이달은 기록이 없어요")
                .style(.b2, .bold, .white)
        }
        .padding(.s5)
        .background {
            Capsule(style: .continuous)
                .fill(DColor.textGuide.opacity(0.9))
        }
    }
}
