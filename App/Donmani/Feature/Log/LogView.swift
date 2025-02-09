//
//  LogView.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct LogView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<LogStore>
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            VStack(
                alignment: .center,
                spacing: .defaultLayoutPadding
            ) {
                // Navigation Bar
                HStack {
                    DBackButton {
                        store.send(.showCancelRecordBottomSheet)
                    }
                    Spacer()
                    DayToggle()
                }
                .frame(height: .navigationBarHeight)
                
                Text(store.title)
                    .font(DFont.font(.h1, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                // 기록 버튼
                VStack(
                    alignment: .leading,
                    spacing: .s4
                ) {
                    //                    LogButton(title: "행복", type: .good)
                    //                    {
                    //                        LogWritingStore.view(type: .good)
                    //                    }
                    //                    LogButton(title: "후회", type: .bad)
                    //                    {
                    //                        LogWritingStore.view(type: .bad)
                    //                        Text("후회")
                    //                    }
                    LogButton(type: .good)
                    LogButton(type: .bad)
                    LogEmptyButton(
                        isChecked: store.isEmptyRecord
                    ) {
                        store.send(.showEmptyRecordBottomSheet)
                    }
                }
                .navigationDestination(for: RecordContentType.self) { recordType in
                    LogWritingView(
                        store: Store(
                            initialState: LogWritingStore.State(
                                type: recordType
                            )
                        ) {
                            LogWritingStore()
                        }
                    )
//                    LogWritingStore.view(type: recordType)
                }
                
                Spacer()
                
                // 저장
                VStack(spacing: 0) {
                    Text("너의 소비를 별사탕으로 바꿔줄게!")
                        .font(DFont.font(.b2, weight: .semibold))
                        .foregroundStyle(DColor(.pupleBlue90).color)
                        .padding(8)
                    DButton(
                        title: "저장하기",
                        isEnabled: store.isSaveEnabled
                    ) {
                        store.send(.showSaveBottomSheet)
                    }
                    .padding(8)
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
            
            if store.isPresentingRecordEmpty {
                RecordEmptyConfirmView()
            }
            
            if store.isPresentingCancel {
                CancelRecordConfirmView()
            }
            
            if store.isPresentingRecordComplete {
                RecordSaveConfirmView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LogView(
        store: Store(
            initialState: LogStore.State(
                isCompleteToday: false,
                isCompleteYesterday: false
            )
        ) {
            LogStore()
        }
    )
}
