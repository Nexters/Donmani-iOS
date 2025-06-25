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
    let completeHandler: ((Record) -> Void)?
    
    init(
        store: StoreOf<RecordEntryPointStore>,
        completeHandler: @escaping (Record) -> Void
    ) {
        self.store = store
        self.completeHandler = completeHandler
    }
    
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
                            dismiss()
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
                    DText(store.isReadyToSave ? "저장하면 수정할 수 없어요!" : store.title)
                        .style(.h1, .bold, .white)
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
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
            
            if store.isPresentingRecordEmpty {
                RecordEmptyConfirmView()
            }
            
            if store.isPresentingCancel {
                CancelRecordConfirmView()
                    .onAppear {
                        store.send(.sendCancelGAEvent)
                    }
            }
            
            if store.isLoading {
                Color.black.opacity(0.1)
            }
        }
        .onAppear {
            store.send(.startTimer)
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    {
        let context = RecordEntryPointStore.Context(today: false, yesterday: true)
        let state = MainStateFactory().makeRecordEntryPointState(context: context)
        let store = MainStoreFactory().makeRecordEntryPointStore(state: state)
        return RecordEntryPointView(store: store) { _ in }
    }()
}
