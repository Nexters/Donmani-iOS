//
//  MainView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SwiftUI
import DesignSystem

extension MainView {
    func AccessoryButton(
        asset: DImageAsset,
        destination: () -> some View
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            ZStack {
                Circle()
                    .fill(DColor.accessoryButton)
                    .opacity(0.1)
                DImage(asset).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3)
            }
        }
        .frame(width: 48, height: 48)
    }
    
    func RecordButton() -> some View {
        Button {
            store.send(.touchRecordEntryButton)
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
    
    func guidePopoverView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                HStack {
                    Text("어제 소비도 정리해 보아요")
                        .font(DFont.font(.b3, weight: .medium))
                        .foregroundStyle(.white)
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
    
//    func StarEffectView(
//        record: Record
//    ) -> some View {
//        Color.black.opacity(0.9)
//            
//    }
    
}
