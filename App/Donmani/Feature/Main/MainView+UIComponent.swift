//
//  MainView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

extension MainView {
//    func AccessoryButton(
//        asset: DImageAsset,
//        action: @escaping () -> Void
//    ) -> some View {
//        Button {
//            action()
//        } label: {
//            DImage(asset).image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: .s3)
//        }
//        .frame(width: .s3, height: .s3)
//    }
    
    func RecordButton() -> some View {
        Button {
            GA.Click(event: .mainRecordButton).send()
            store.send(.delegate(.pushRecordEntryPointView))
        } label: {
            ZStack {
                Circle()
                    .fill(DColor(.pupleBlue70).color)
                DImage(.plus).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s2)
            }
        }
        .frame(width: 70, height: 70)
    }
    
    func RecordYesterdayViewToolTip() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                HStack {
                    DText("어제 소비도 정리해 보아요")
                        .style(.b3, .medium, .white)
                    Button {
                        store.send(.closePopover)
                    } label: {
                        DImage(.close).image
                            .resizable()
                            .frame(width: .s5, height: .s5)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Spacer()
            }
            HStack {
                Spacer()
                Triangle(direction: .down)
                    .fill(.black)
                    .frame(width: 14, height: 8)
                Spacer()
            }
        }
    }
    
    func RewardToopTipView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Triangle(direction: .up)
                    .fill(DColor(.deepBlue70).color)
                    .frame(width: 14, height: 8)
                    .padding(.trailing, 12)
            }
            HStack {
                Spacer()
                DText("선물 도착!✨")
                    .style(.b3, .semibold, .white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(DColor(.deepBlue70).color)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            Spacer()
        }
        .padding(.top, 42)
        .padding(.horizontal, 13)
    }
}
