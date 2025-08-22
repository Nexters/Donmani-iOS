//
//  StatisticsView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 3/28/25.
//

import SwiftUI
import DesignSystem

extension StatisticsView {
    func TopBannerView() -> some View {
        HStack(alignment: .top, spacing: .s5 / 2) {
            VStack {
                DImage(.notice).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
            }
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    DText("요약 페이지가 곧 업데이트 될거예요")
                        .style(.b1, .semibold, .gray95)
                    DText("기록을 모아 분석해 드릴게요!")
                        .style(.b2, .regular, .deepBlue95)
                }
                Button {
                    store.send(.touchProposeFunction)
                } label: {
                    HStack(spacing: 4) {
                        DText("기능 요청하기")
                            .style(.b2, .medium, .deepBlue99)
                        
                        DImage(.rightArrow).image
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(DColor(.deepBlue99).color)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s5, height: .s5)
                    }
                }
            }
            Spacer()
        }
        .padding(.s5)
        .background {
            RoundedRectangle(cornerRadius: .s5, style: .circular)
                .fill(DColor(.deepBlue60).color)
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    func CategoryStatisticsView(flag: RecordContentType) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            DText("\(flag.title) 소비 \(flag == .good ? store.goodTotalCount : store.badTotalCount)")
                .style(.b1, .bold, .gray99)
            ForEach(RecordCategory.cases(type: flag), id: \.self) { category in
                CategoryRatioView(
                    flag: flag,
                    category: category,
                    ratio: store.recordRatio[category, default: 0.0]
                )
            }
        }
        .padding(.s5)
        .background {
            RoundedRectangle(cornerRadius: .s4, style: .circular)
                .fill(DColor(.deepBlue70).color)
        }
        .padding(.horizontal, .defaultLayoutPadding)
    }
    
    func CategoryRatioView(
        flag: RecordContentType,
        category: RecordCategory,
        ratio: CGFloat
    ) -> some View {
        HStack {
            HStack(spacing: 12) {
                category
                    .miniImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s1, height: .s1)
                DText(category.title)
                    .style(.b2, .medium, .gray95)
            }
            
            Spacer()
            
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(
                                color: DColor(.deepBlue99).color,
                                location: ratio
                            ),
                            .init(
                                color: DColor(.deepBlue80).color,
                                location: ratio
                            )
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: .screenWidth / 3, height: 6)
            VStack(alignment: .trailing) {
                DText("\(String(format: "%.f", ratio * 100))%")
                    .style(.b2, .semibold, .gray95)
                    .frame(width: 40)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}
