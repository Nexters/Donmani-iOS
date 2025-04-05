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
                        DText("\(store.yearMonth.year)년 \(store.yearMonth.month)월 기록 통계")
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
                        CategoryStatisticsView(flag: .bad)
                    }
                }
            }
        }
        .sheet(isPresented: $store.isPresentingProposeFunctionView) {
            // Propose Function WebView
            InnerWebView(urlString: DURLManager.proposeFunction.urlString)
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    StatisticsView()
//}
