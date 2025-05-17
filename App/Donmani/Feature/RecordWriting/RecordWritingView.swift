//
//  RecordWritingView.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct RecordWritingView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<RecordWritingStore>
    @FocusState var isFocusToTextField: Bool
    @State var editingText: String = ""
    let completeHandler: ((RecordContent?) -> Void)?
    
    init(
        store: StoreOf<RecordWritingStore>,
        completeHandler: @escaping (RecordContent?) -> Void
    ) {
        self.store = store
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            if let categoryColor = store.savedCategory?.color {
                ColorBackgroundView(color: categoryColor)
            }
            VStack(spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            if (editingText.count > 0) {
                                isFocusToTextField = false
                                store.send(.showCancelRecordBottomSheet)
                            } else {
                                dismiss()
                            }
                        }
                        Spacer()
                    }
                    DText("\(store.type.title) 소비")
                        .style(.b1, .bold, .white)
                }
                .padding(.vertical, 14)
                
                VStack(spacing: .defaultLayoutPadding) {
                    ZStack {
                        Button {
                            store.send(.openCategory)
                        } label: {
                            store.sticker
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: .stickerSize, height: .stickerSize)
                                .overlay {
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Spacer()
                                            DImage(.editCategory).image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(
                                                    width: .screenWidth * (40.0/375.0),
                                                    height: .screenWidth * (40.0/375.0)
                                                )
                                                .offset(x: .screenWidth * (40.0/375.0) / 2.0, y: 0)
                                        }
                                        Spacer()
                                    }
                                }
                        }
                    }
                    DText(store.savedCategory?.title ?? " ")
                        .style(.h3, .bold, .white)
                        .opacity((store.savedCategory == nil) ? 0 : 1)
                    
                    VStack(spacing: 4) {
                        TextField(
                            text: $editingText,
                            axis: .vertical
                        ) {
                            DText("소비가 \(store.type.selectTitle)던 이유는?")
                                .style(.b1, .medium, .deepBlue80)
                        }
                        .focused($isFocusToTextField)
                        .font(DFont.font(.b1, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(5...)
                        .lineSpacing(6)
                        .frame(height: 100)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .onChange(of: editingText) { oldValue, newValue in
                            store.send(.textChanged(newValue.count))
                            if newValue.count > 100 {
                                editingText = oldValue
                                store.send(
                                    .showTextLengthGuide,
                                    animation: .linear(duration: 0.5)
                                )
                            }
                            UINavigationController.swipeNavigationPopIsEnabled = (editingText == store.text)
                        }
                        .bind($store.isFocusToTextField, to: $isFocusToTextField)
                        
                        HStack {
                            Spacer()
                            DText("\(editingText.count)/100")
                                .style(.b2, .regular, .deepBlue80)
                        }
                    }
                    .padding(8)
                }
                Spacer()
                
                // Complete Button
                HStack {
                    Spacer()
                    DCompleteButton(
                        isActive: store.isSaveEnabled
                    ) {
                        store.send(.save(editingText))
                    }
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
            .onAppear {
                editingText = store.text
                if store.text.isEmpty {
                    store.send(.openCategory)
                } else {
                    isFocusToTextField = true
                }
            }
            
            TextGuideView()
                .opacity(store.isPresendTextGuide ? 1 : 0)
                .offset(x: 0, y: store.isPresendTextGuide ? 0 : 4)
            
            if store.isPresentingSelectCategory {
                SelectCategoryView()
            }
            if store.isPresentingCancel {
                CancelRecordConfirmView()
                    .onAppear {
                        store.send(.sendCancelGAEvent)
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    {
        let context = RecordWritingStore.Context(type: .good)
        let state = MainStateFactory().makeRecordWritingState(context: context)
        let store = MainStoreFactory().makeRecordWritingStore(state: state)
        return RecordWritingView(store: store) { _ in }
    }()
}

#Preview {
    {
        let context = RecordWritingStore.Context(type: .bad)
        let state = MainStateFactory().makeRecordWritingState(context: context)
        let store = MainStoreFactory().makeRecordWritingStore(state: state)
        return RecordWritingView(store: store) { _ in }
            .SelectCategoryView()
    }()
    
}
