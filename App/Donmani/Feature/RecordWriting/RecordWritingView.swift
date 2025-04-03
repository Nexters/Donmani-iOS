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
                    Text("\(store.type.title) 소비")
                        .font(DFont.font(.b1, weight: .bold))
                        .foregroundStyle(.white)
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
                                            .frame(width: 40, height: 40)
                                            .offset(x: 20, y: 0)
                                        }
                                        Spacer()
                                    }
                                }
                        }
                    }
                    Text(store.savedCategory?.title ?? " ")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity((store.savedCategory == nil) ? 0 : 1)
                    
                    VStack(spacing: 4) {
                        TextField(
                            text: $editingText,
                            axis: .vertical
                        ) {
                            Text("소비가 \(store.type.selectTitle)던 이유는?")
                                .font(DFont.font(.b1, weight: .medium))
                                .foregroundStyle(DColor(.deepBlue80).color)
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
                            Text("\(editingText.count)/100")
                                .font(DFont.font(.b2))
                                .foregroundStyle(DColor(.deepBlue80).color)
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
            }
        }
        .onDisappear {
            store.send(.delegate(.checkSwipeValidation))
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    RecordWritingView(
        store: Store(initialState: RecordWritingStore.State(type: .good)
        ) {
            RecordWritingStore()
        }
    )
}

#Preview {
    RecordWritingView(
        store: Store(initialState: RecordWritingStore.State(type: .good)
        ) {
            RecordWritingStore()
        }
    )
    .SelectCategoryView()
}
