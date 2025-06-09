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
                store.send(.touchDayTypeToggleButton)
            } label: {
                DText("어제")
                    .style(.b2, .semibold, store.dayType == .today ? DColor(.deepBlue80).color : DColor.accessoryButton)
            }
            .padding(12)
            
            DText("|")
                .style(.b2, .regular, .deepBlue80)
            
            Button {
                store.send(.touchDayTypeToggleButton)
            } label: {
                DText("오늘")
                    .style(.b2, .semibold, store.dayType == .today ? DColor.accessoryButton : DColor(.deepBlue80).color)
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
                    DText(type.title)
                        .style(.h3, .bold, .white)
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
                DText(store.guide)
                    .style(.b2, .semibold, .pupleBlue90)
                    .padding(8)
            }
    }
    
    func RecordIsNotFullText() -> some View {
        HStack(alignment: .top, spacing: .s5 / 2) {
            VStack {
                DImage(.notice).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3, height: .s3)
            }
            VStack(spacing: 4) {
                DText("\(store.goodRecord == nil ? "행복" : "후회") 소비를 작성하지 않았어요!")
                    .style(.b1, .semibold, .gray99)
                DText("돌아가기를 누르면 기록할 수 있어요")
                    .style(.b2, .regular, .gray99)
                
            }
            Spacer()
        }
        .padding(.s5)
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
                            DText("선택하면 무소비 날도 기록할 수 있어요!")
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
                DText("무소비 했어요")
                    .style(.b2, .semibold, isChecked ? .gray95 : .deepBlue80)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
    
    func RecordArea() -> some View {
        Group {
            if store.isCheckedEmptyRecord {
                EmptyRecordView()
            } else {
                if let goodRecord = store.goodRecord, let badRecord = store.badRecord {
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
                } else {
                    if let goodRecord = store.goodRecord {
                        Button {
                            store.send(.delegate(.pushRecordWritingViewWith(goodRecord)))
                        } label: {
                            RecordView(record: goodRecord, isEditable: true)
                        }
                    } else {
                        if !store.isReadyToSave {
                            RecordWritingButton(type: .good)
                        }
                    }
                    if let badRecord = store.badRecord {
                        Button {
                            store.send(.delegate(.pushRecordWritingViewWith(badRecord)))
                        } label: {
                            RecordView(record: badRecord, isEditable: true)
                        }
                    } else {
                        if !store.isReadyToSave {
                            RecordWritingButton(type: .bad)
                        }
                    }
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
                    DText("돌아가기")
                        .style(.h3, .bold, .white)
                }
            }
            
            Button {
                Task {
                    await store.send(.completeWrite).finish()
                    if !store.isError, let record = store.record {
                        completeHandler?(record)
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: 16.0,
                        style: .continuous
                    )
                    .fill(DColor(.gray95).color)
                    .frame(height: 58)
                    DText("확인 했어요")
                        .style(.h3, .bold, .deepBlue20)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
