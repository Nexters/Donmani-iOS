//
//  RecordIntegrateView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem


struct RecordIntegrateView: View {
    let goodRecord: RecordContent
    let badRecord: RecordContent
    
    let goodAction: (() -> Void)?
    let badAction: (() -> Void)?
    
    init(
        goodRecord: RecordContent,
        badRecord: RecordContent,
        goodAction: (() -> Void)? = nil,
        badAction: (() -> Void)? = nil
    ) {
       self.goodRecord = goodRecord
        self.badRecord = badRecord
        self.goodAction = goodAction
        self.badAction = badAction
    }
    
    var body: some View {
        VStack {
            Button {
                goodAction?()
            } label: {
                RecordContentView(record: goodRecord, isEditable: goodAction != nil)
            }
            .allowsHitTesting(goodAction != nil)
            
            Button {
                badAction?()
            } label: {
                RecordContentView(record: badRecord, isEditable: badAction != nil)
            }
            .allowsHitTesting(badAction != nil)
        }
        .background(
            ZStack {
                RoundedRectangle(
                    cornerRadius: .defaultLayoutPadding,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        colors: [
                            goodRecord.category.color,
                            badRecord.category.color
                        ]
                        , startPoint: .topLeading
                        , endPoint: .bottomTrailing
                    )
                    .opacity(0.5)
                )
                RoundedRectangle(
                    cornerRadius: .defaultLayoutPadding,
                    style: .continuous
                )
                .fill(.white.opacity(0.1))
                RoundedRectangle(
                    cornerRadius: .defaultLayoutPadding,
                    style: .continuous
                )
                .strokeBorder(.white.opacity(0.1), lineWidth: 2)
            }
        )
    }
}

//#Preview {
//    RecordIntegrateView()
//}
