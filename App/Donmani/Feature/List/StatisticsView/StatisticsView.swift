//
//  StatisticsView.swift
//  Donmani
//
//  Created by 문종식 on 3/28/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import DNetwork

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<StatisticsStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center,spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Spacer()
                        DText("\(store.day.year)년 \(store.day.month)월 기록 통계")
                            .style(.b1, .semibold, .white)
                        Spacer()
                    }
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                        Spacer()
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                ScrollView {
                    VStack(spacing: .s3) {
                        TopBannerView()
                        CategoryStatisticsView(flag: .good)
                            .onAppear {
                                GA.Impression(event: .insight).send(parameters: [.good: "Good"])
                            }
                        CategoryStatisticsView(flag: .bad)
                            .onAppear {
                                GA.Impression(event: .insight).send(parameters: [.bad: "Bad"])
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $store.isPresentingProposeFunctionView) {
            // Propose Function WebView
            InnerWebView(urlString: DURL.proposeFunction.urlString)
        }
        .onAppear {
            GA.View(event: .insight).send()
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    StatisticsView()
//}
