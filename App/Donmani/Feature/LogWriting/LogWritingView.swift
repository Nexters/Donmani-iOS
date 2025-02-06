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
    @Bindable var store: StoreOf<LogWritingReducer>
    @State var isPresenting: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            DImage(.leftArrow).image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: .s3)
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
                        TextEditor(
                            text: .constant("asdf")
//                            text: Binding(
//                                get: { return store.text },
//                                set: { v, t in
////                                    store.send(.write(v))
//                                }
//                            )
                        )
                        .frame(height: 100)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        
                        
                        HStack {
                            Spacer()
                            Text("\(store.text.count)/100")
                                .font(DFont.font(.b2))
                        }
                    }
                    .padding(8)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        ZStack {
                            // TODO: - Edit Color
                            Capsule(style: .circular)
                                .fill(DColor(.gray95).color)
                            Text("완료")
                                .font(DFont.font(.b1, weight: .bold))
                                .foregroundStyle(DColor(.deepBlue10).color)
                        }
                    }
                    .frame(width: 60, height: 40)
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
        }
        .navigationBarBackButtonHidden()
        .customBottomSheet(isPresented: $isPresenting) {
            Text("BottomSheet")
                .frame(height: 150)
                .background(.white)
        }
    }
}

#Preview {
    LogWritingView(
        store: Store(
            initialState: LogWritingReducer.LogWritingState(
                type: .good
            ),
            reducer: {
                
            }
        )
    )
}
