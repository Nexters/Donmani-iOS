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
            VStack(alignment: .center,spacing: 0) {
                DNavigationBar(
                    leading: {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                    },
                    title: {
                        DText("\(store.day.year)년 \(store.day.month)월 기록 통계")
                            .style(.b1, .semibold, .white)
                    }
                )
                
                ScrollView {
                    VStack(spacing: .s3) {
                        TopBannerView()
                        CategoryStatisticsView(flag: .good)
                            .onAppear {
                                GA.Impression(event: .insight)
                                    .send(parameters: [.good: "Good"])
                            }
                        CategoryStatisticsView(flag: .bad)
                            .onAppear {
                                GA.Impression(event: .insight)
                                    .send(parameters: [.bad: "Bad"])
                            }
                    }
                    .padding(.bottom, 40)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .background {
            BackgroundView()
        }
        .sheet(isPresented: $store.isPresentingProposeFunctionView) {
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
