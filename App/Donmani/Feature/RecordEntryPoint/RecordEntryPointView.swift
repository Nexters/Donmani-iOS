//
//  RecordEntryPointView.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct RecordEntryPointView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<RecordEntryPointStore>
    
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
                
                ScrollView {
                    Text(store.title)
                        .font(DFont.font(.h1, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.bottom, 40)
                    
                    // 기록 버튼
                    VStack(
                        alignment: .leading,
                        spacing: .defaultLayoutPadding
                    ) {
                        RecordArea()
                        EmptyRecordButton(isChecked: store.isCheckedEmptyRecord) {
                            store.send(.touchEmptyRecordButton)
                        }
                        Spacer()
                    }
                    
                    
                    Spacer()
                }
                
                // 저장
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        DImage(.save).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: .s4)
                        Text("기록하고 별사탕 받자!")
                            .font(DFont.font(.b2, weight: .semibold))
                            .foregroundStyle(DColor(.pupleBlue90).color)
                            .padding(8)
                    }
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
        .navigationDestination(isPresented: $store.isPresentingRecordWritingView) {
            let recordWritingStore = store.scope(state: \.recordWritingState, action: \.setRecord)
            return RecordWritingView(store: recordWritingStore)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RecordEntryPointView(
        store: Store(
            initialState: RecordEntryPointStore.State(
                isCompleteToday: false,
                isCompleteYesterday: false
            )
        ) {
            RecordEntryPointStore()
        }
    )
}
