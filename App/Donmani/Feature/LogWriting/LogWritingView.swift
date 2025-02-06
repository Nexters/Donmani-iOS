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
                    .padding(.horizontal, .defaultLayoutPadding)
                    Text(store.type.title)
                        .font(DFont.font(.b1, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 14)
                VStack(spacing: .defaultLayoutPadding) {
                    store.sticker
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .stickerSize, height: .stickerSize)
                    
                    Text("카테고리")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity((store.selectedCategory == nil) ? 0 : 1)
                    
                    VStack(spacing: 4) {
                        TextEditor(
                            text: Binding(
                                get: { return store.text },
                                set: { v, t in
//                                    store.send(.write(v))
                                }
                            )
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
                                .fill(.white)
                            Text("완료")
                                .font(DFont.font(.b1, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(width: 60, height: 40)
                }
            }
            .padding(.horizontal, .defaultLayoutPadding)
        }
        .navigationBarBackButtonHidden()
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
