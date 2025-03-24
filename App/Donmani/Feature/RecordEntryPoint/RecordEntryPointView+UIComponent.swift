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
                store.send(.touchYesterdayToggleButton)
            } label: {
                Text("어제")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(store.dayType == .today ? DColor(.deepBlue80).color : DColor.accessoryButton)
            }
            .padding(12)
            
            Text("|")
                .font(DFont.font(.b2, weight: .regular))
                .foregroundStyle(DColor(.deepBlue80).color)
            
            Button {
                store.send(.touchTodayToggleButton)
            } label: {
                Text("오늘")
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(store.dayType == .today ? DColor.accessoryButton : DColor(.deepBlue80).color)
            }
            .padding(12)
        }
    }
    
    
    func RecordWritingButton(
        type: RecordContentType
    ) -> some View {
        Button {
            store.send(.delegate(.pushRecordWritingView(type)))
        } label: {
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
    
    func RecordGuideText() -> some View {
            HStack(spacing: 0) {
                DImage(.starShape).image
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(DColor(.pupleBlue90).color)
                    .frame(width: 22)
                Text(store.guide)
                    .font(DFont.font(.b2, weight: .semibold))
                    .foregroundStyle(DColor(.pupleBlue90).color)
                    .padding(8)
            }
    }
    
    func EmptyRecordArea() -> some View {
        VStack(spacing: 2) {
            HStack {
                EmptyRecordButton(isChecked: store.isCheckedEmptyRecord) {
                    store.send(.touchEmptyRecordButton)
                }
                Spacer()
            }
            if store.isPresentingPopover {
                VStack(spacing: 0) {
                    HStack {
                        Triangle()
                            .fill(.black)
                            .frame(width: 14, height: 8)
                            .padding(.leading, 11)
                        Spacer()
                    }
                    HStack {
                        HStack {
                            Text("선택하면 무소비 날도 기록할 수 있어요!")
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
                }
            }
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
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
    
    func RecordArea() -> some View {
        Group {
            if store.isSaveEnabled {
                if store.isCheckedEmptyRecord {
                    EmptyRecordView()
                } else if let goodRecord = store.goodRecord,
                          let badRecord = store.badRecord {
                    RecordIntegrateView(
                        goodRecord: goodRecord,
                        badRecord: badRecord,
                        goodAction: {
                            store.send(.delegate(.pushRecordWritingViewWith(goodRecord)))
                        },
                        badAction: {
                            store.send(.delegate(.pushRecordWritingViewWith(badRecord)))
                        }
                    )
                }
            } else {
                if let goodRecord = store.goodRecord {
                    RecordView(record: goodRecord) {
                        store.send(.delegate(.pushRecordWritingViewWith(goodRecord)))
                    }
                } else {
                    RecordWritingButton(type: .good)
                }
                if let badRecord = store.badRecord {
                    RecordView(record: badRecord) {
                        store.send(.delegate(.pushRecordWritingViewWith(badRecord)))
                    }
                } else {
                    RecordWritingButton(type: .bad)
                }
            }
        }
    }
    
    func ReadyToSaveButton() -> some View {
        HStack(spacing: 10) {
            Button {
                store.send(.cancelSave)
            } label: {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: 16.0,
                        style: .continuous
                    )
                    .fill(DColor(.deepBlue50).color)
                    .frame(height: 58)
                    Text("돌아가기")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            
            Button {
                store.send(.save)
            } label: {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: 16.0,
                        style: .continuous
                    )
                    .fill(DColor(.gray95).color)
                    .frame(height: 58)
                    Text("확인 했어요")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(DColor(.deepBlue20).color)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
