//
//  RecordCardView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem


struct RecordCardView: View {
    let goodRecord: RecordContent?
    let badRecord: RecordContent?
    
    let goodAction: (() -> Void)?
    let badAction: (() -> Void)?
    
    var backgroundColors: [Color] {
        var colors: [Color] = []
        if let goodRecord {
            colors.append(goodRecord.category.color)
        }
        if let badRecord {
            colors.append(badRecord.category.color)
        }
        return colors
    }
    
    init(
        goodRecord: RecordContent? = nil,
        badRecord: RecordContent? = nil,
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
            if let goodRecord {
                Button {
                    goodAction?()
                } label: {
                    RecordContentView(record: goodRecord, isEditable: goodAction != nil)
                }
                .allowsHitTesting(goodAction != nil)
            }
            
            if let badRecord {
                Button {
                    badAction?()
                } label: {
                    RecordContentView(record: badRecord, isEditable: badAction != nil)
                }
                .allowsHitTesting(badAction != nil)
            }
        }
        .background(
            ZStack {
                RoundedRectangle(
                    cornerRadius: .defaultLayoutPadding,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        colors: backgroundColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
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
