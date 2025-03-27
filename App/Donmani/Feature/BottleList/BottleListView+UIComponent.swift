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
                Text("매 월 1일에 새로운 별통이가 열려요")
                    .font(DFont.font(.b1, weight: .regular))
                    .foregroundStyle(DColor(.gray95).color)
                Spacer()
                Button {
                    
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
                    Spacer()
                }
            }
        }
//        Grid(
//            alignment: .center,
//            horizontalSpacing: 0,
//            verticalSpacing: .s3
//        ) {
//            ForEach(
//                0..<store.rowIndex, id: \.self
//            ) { row in
//                GridRow {
//                    ForEach(
//                        0..<(starCountSort.count % 3) + 1, id: \.self
//                    ) { col in
//                        HStack {
//                            Spacer()
//                            MonthlyBottleView(
//                                month: starCountSort[row * 3 + col].0,
//                                count: starCountSort[row * 3 + col].1
//                            )
//                            Spacer()
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func MonthlyBottleView(
        month: Int,
        count: Int
    ) -> some View {
        VStack(alignment: .center, spacing: 4) {
            if (count == -1) {
                DImage(.lockedBottle).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 116)
            } else {
                ZStack {
                    DImage(.openedBottle).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack(spacing: 4) {
                        DImage(.smallStar).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s4, height: .s4)
                    }
                }
                .frame(height: 116)
            }
            
            Text("\(month)월")
                .font(DFont.font(.b2, weight: .semibold))
                .foregroundStyle(DColor(
                    (count > -1) ? .gray99 : .deepBlue80
                ).color)
        }
    }
}
