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
//    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<RecordEntryPointStore>
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            if store.isReadyToSave {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                }
                .padding(-1)
            }
            VStack(
                alignment: .center,
                spacing: .defaultLayoutPadding
            ) {
                // Navigation Bar
                HStack {
                    DNavigationBarButton(.leftArrow) {
                        if (
                            store.isCheckedEmptyRecord
                            || store.goodRecord != nil
                            || store.badRecord != nil
                        ) {
                            store.send(.showCancelRecordBottomSheet)
                        } else {
                            store.send(.delegate(.popToMainView(nil)))
                        }
                    }
                    Spacer()
                    if (store.isPresentingDayToggle) {
                        DayToggle()
                    }
                }
                .frame(height: .navigationBarHeight)
                .opacity(store.isReadyToSave ? 0 : 1)
                
                ScrollView {
                    Text(store.isReadyToSave ? "저장하면 수정할 수 없어요!" : store.title)
                        .font(DFont.font(.h1, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.bottom, 40)
                    
                    // 기록 버튼
                    VStack(
                        alignment: .leading,
                        spacing: .defaultLayoutPadding
                    ) {
                        RecordArea()
                        if !store.isReadyToSave {
                            EmptyRecordArea()
                        }
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
                // 저장
                VStack(spacing: 0) {
                    if !store.isReadyToSave || store.isFullWriting {
                        RecordGuideText()
                    } else {
                        RecordIsNotFullText()
                    }
                    
                    if store.isReadyToSave {
                        ReadyToSaveButton()
                    } else {
                        DButton(
                            title: "저장하기",
                            isEnabled: store.isSaveEnabled
                        ) {
                            store.send(.readyToSave)
                        }
                        .padding(8)
                    }
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
            
            if store.isPresentingRecordEmpty {
                RecordEmptyConfirmView()
            }
            
            if store.isPresentingCancel {
                CancelRecordConfirmView()
            }
            
            if store.isPresentingRecordGuideView {
                RecordGuideView()
            }
            
            if store.isLoading {
                Color.black.opacity(0.1)
            }
        }
        .onAppear {
            store.send(.startTimer)
        }
//        .navigationDestination(isPresented: $store.isPresentingRecordWritingView) {
//            let recordWritingStore = store.scope(state: \.recordWritingState, action: \.recordWritingAction)
//            RecordWritingView(store: recordWritingStore)
//        }
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
