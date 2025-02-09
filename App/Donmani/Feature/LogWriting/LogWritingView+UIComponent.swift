//
//  LogWritingView+UIComponent.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import SwiftUI
import DesignSystem

extension LogWritingView {
    static let categoryColumns = Array(
        repeating: GridItem(.flexible(minimum: 100, maximum: 500)),
        count: 3
    )
    
    func SelectCategoryView() -> some View {
        BottomSheetView(
            closeAction: { store.send(.closeCategory) }
        ) { _ in
            Text("어떤 \(store.type.title)였나요?")
                .font(DFont.font(.h2, weight: .bold))
                .foregroundStyle(.white)
            LazyVGrid(
                columns: LogWritingView.categoryColumns,
                spacing: .s3
            ) {
                ForEach(store.category.indices, id: \.self) { i in
                    Button{
                        store.send(.selectCategory(store.category[i]))
                    } label: {
                        VStack(spacing: 4) {
                            DImage(.tempImage).image
                                .frame(width: 62, height: 62)
                            Text(store.category[i].title)
                                .font(DFont.font(.b2, weight: .semibold))
                                .foregroundStyle(DColor(.deepBlue90).color)
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .padding(.vertical , 24)
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: 16.0,
                        style: .continuous
                    )
                    .fill(DColor(.deepBlue20).color)
                    .frame(height: 58)
                    Text("완료")
                        .font(DFont.font(.h3, weight: .bold))
                        .foregroundStyle(DColor(.deepBlue70).color)
                }
            }
        }
    }
    
//    func SelectCategoryView2() -> some View {
//        ZStack {
//            Color(.black)
//                .opacity(store.isPresentingSelectCategory ? 0.6 : 0)
//                .onTapGesture {
//                    dismissSelectCatetoryView()
//                }
//                .animation(.easeInOut(duration: 0.3), value: store.isPresentingSelectCategory)
//                .ignoresSafeArea()
//            
//            if store.isPresentingSelectCategory {
//                VStack {
//                    Spacer()
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Spacer()
//                            Button {
//                                dismissSelectCatetoryView()
//                            } label: {
//                                DImage(.close).image
//                                    .resizable()
//                                    .frame(width: .s2, height: .s2)
//                            }
//                        }
//                        
//                        Text("어떤 \(store.type.title) 소비였나요?")
//                            .font(DFont.font(.h2, weight: .bold))
//                            .foregroundStyle(.white)
//                        LazyVGrid(
//                            columns: LogWritingView.categoryColumns,
//                            spacing: .s3
//                        ) {
//                            ForEach(store.category.indices, id: \.self) { i in
//                                Button{
//                                    store.send(.selectCategory(store.category[i]))
//                                } label: {
//                                    VStack(spacing: 4) {
//                                        DImage(.tempImage).image
//                                            .frame(width: 62, height: 62)
//                                        Text(store.category[i].title)
//                                            .font(DFont.font(.b2, weight: .semibold))
//                                            .foregroundStyle(DColor(.deepBlue90).color)
//                                    }
//                                }
//                                .padding(.horizontal, 15)
//                            }
//                        }
//                        .padding(.vertical , 24)
//                        Button {
//                            
//                        } label: {
//                            ZStack {
//                                RoundedRectangle(
//                                    cornerRadius: 16.0,
//                                    style: .continuous
//                                )
//                                .fill(DColor(.deepBlue20).color)
//                                .frame(height: 58)
//                                Text("완료")
//                                    .font(DFont.font(.h3, weight: .bold))
//                                    .foregroundStyle(DColor(.deepBlue70).color)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, .defaultLayoutPadding)
//                    .padding(.vertical, 20)
//                    .background {
//                        DColor(.deepBlue60).color
//                            .clipShape(
//                                .rect(
//                                    topLeadingRadius: .s1,
//                                    bottomLeadingRadius: 0,
//                                    bottomTrailingRadius: 0,
//                                    topTrailingRadius: .s1,
//                                    style: .continuous
//                                )
//                            )
//                            .ignoresSafeArea(.all, edges: .bottom)
//                    }
//                }
//                .transition(.move(edge: .bottom))
//                .animation(.easeOut(duration: 0.3), value: store.isPresentingSelectCategory)
//            }
//        }
//    }
    
//    private func dismissSelectCatetoryView() {
//        withAnimation {
//            store.send(.closeCategory)
//        }
//    }
}
