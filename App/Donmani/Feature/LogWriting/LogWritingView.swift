//
//  LogWritingView.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct LogWritingView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<LogWritingStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
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
                    Button {
                        store.send(.openCategory)
                    } label: {
                        store.sticker
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: .stickerSize, height: .stickerSize)
                    
                    Text("카테고리")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity((store.selectedCategory == nil) ? 0 : 1)
                    
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
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Capsule(style: .circular)
                                .fill(DColor(.gray95).color)
                            Text("완료")
                                .font(DFont.font(.b1, weight: .bold))
                                .foregroundStyle(DColor(.deepBlue10).color)
                        }
                    }
                    .frame(width: 60, height: 40)
                    .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
            if store.isPresentingSelectCategory {
                self.SelectCategoryView()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if store.text.isEmpty {
                store.send(.openCategory)
            }
        }
    }
    
}

#Preview {
    LogWritingView(
        store: Store(
            initialState: LogWritingStore.State(
                type: .good
            )
        ) {
            LogWritingStore()
        }
    )
}

#Preview {
    LogWritingView(
        store: Store(
            initialState: LogWritingStore.State(
                type: .bad
            )
        ) {
            LogWritingStore()
        }
    )
    .SelectCategoryView()
}
