//
//  RecordEntryPointView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import DesignSystem

extension RecordEntryPointView {
    // 오늘/내일 토글
    func DayToggle() -> some View {
        HStack(spacing: 0) {
            Button {
                
            } label: {
                Text("어제")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(DColor(.deepBlue80).color)
            }
            .padding(12)
            
            Text("|")
                .font(DFont.font(.b2, weight: .regular))
                .foregroundStyle(DColor(.deepBlue80).color)
            
            Button {
                
            } label: {
                Text("오늘")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(DColor.accessoryButton)
            }
            .padding(12)
        }
    }
    
    
    func RecordWritingButton(
        type: RecordContentType
    ) -> some View {
        NavigationLink(value: type) {
            ZStack {
                RoundedRectangle(
                    cornerRadius: .s3,
                    style: .continuous
                )
                .fill(.white.opacity(0.1))
                HStack {
                    Text(type.title)
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    DImage(.addLog).image
                        .resizable()
                        .frame(width: .s1, height: .s1)
                }
                .padding(.defaultLayoutPadding)
            }
        }
        .frame(height: 118)
    }
    
    func RecordBackgroundView(
        categoryColor: Color
    ) -> some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: .defaultLayoutPadding,
                style: .continuous
            )
            .fill(categoryColor.opacity(0.5))
            RoundedRectangle(
                cornerRadius: .defaultLayoutPadding,
                style: .continuous
            )
            .fill(.white.opacity(0.1))
        }
    }
    
    func RecordContentView(
        record: RecordContent
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(record.category.title)
                    .font(DFont.font(.h3, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    
                } label: {
                    DImage(.edit).image
                        .resizable()
                        .frame(width: .s4, height: .s4)
                }
            }
            HStack(spacing: 12) {
                DImage(record.flag == .good ? .goodLog : .badLog).image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 78)
                Text(record.memo)
                    .font(DFont.font(.b1, weight: .medium))
                    .foregroundStyle(DColor(.gray95).color)
                    .lineLimit(10)
            }
        }
        .padding(.defaultLayoutPadding)
        .background {
            RecordBackgroundView(
                categoryColor: (record.flag == .good ? DColor.tempGood : DColor.tempBad)
            )
        }
    }
    
    func EmptyRecordButton(
        isChecked: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                DImage(isChecked ? .check : .uncheck).image
                    .resizable()
                    .frame(width: .s4, height: .s4)
                Text("무소비 했어요")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle((isChecked ? DColor(.gray95) : DColor(.deepBlue80)).color)
            }
        }
    }
    
    func EmptyRecordView() -> some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: .s3,
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        DColor(.gray70).color,
                        DColor(.gray90).color
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(0.2)
            VStack(alignment: .center, spacing: .defaultLayoutPadding) {
                Text("오늘은 무소비 데이!")
                    .font(DFont.font(.h2, weight: .bold))
                    .foregroundStyle(DColor(.gray95).color)
                DImage(.emptyRecord).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth / 2)
            }
            .padding(.defaultLayoutPadding + 8)
        }
        .frame(height: 256)
    }
}
