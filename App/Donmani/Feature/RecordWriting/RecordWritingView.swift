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
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RecordWritingStore>
    
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
                        DBackButton {
                            dismiss()
                        }
                        Spacer()
                    }
                    Text(store.type.title)
                        .font(DFont.font(.b1, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 14)
                
                VStack(spacing: .defaultLayoutPadding) {
                    ZStack {
                        store.sticker
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        .frame(width: .stickerSize, height: .stickerSize)
                        .overlay {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Spacer()
                                    Button {
                                        store.send(.openCategory)
                                    } label: {
                                        DImage(.editCategory).image
                                    }
                                    .frame(width: 40, height: 40)
                                    .offset(x: 20, y: 0)
                                }
                                Spacer()
                            }
                        }
                    }
                    Text(store.savedCategory?.title ?? " ")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity((store.savedCategory == nil) ? 0 : 1)
                    
                    VStack(spacing: 4) {
                        TextField(
                            text: $store.text,
                            axis: .vertical
                        ) {
                            Text("어떤 소비를 했나요?")
                                .font(DFont.font(.b1, weight: .medium))
                                .foregroundStyle(DColor(.deepBlue80).color)
                        }
                        .font(DFont.font(.b1, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(5...)
                        .frame(height: 100)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        
                        HStack {
                            Spacer()
                            Text("\(store.textCount)/100")
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
                    SaveButton(
                        iaActive: store.isSaveEnabled
                    ) {
                        store.send(.save)
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
            .onAppear {
                if store.text.isEmpty {
                    store.send(.openCategory)
                }
            }
            
            if store.isPresendTextGuide {
                TextGuideView()
            }
            if store.isPresentingSelectCategory {
                SelectCategoryView()
            }
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
