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
    
//    func StarEffectView(
//        record: Record
//    ) -> some View {
//        Color.black.opacity(0.9)
//            
//    }
}
