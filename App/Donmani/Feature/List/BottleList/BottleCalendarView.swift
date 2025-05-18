//
//  BottleCalendarView.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct BottleCalendarView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<BottleCalendarStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center,spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Spacer()
                        DText("별통이 모아보기")
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
                    if store.isPresentingTopBanner {
                        TopBannerView()
                    }
                    MonthlyBottleGridView()
                        .padding(.top, 16)
                }
            }
            VStack {
                Spacer()
                TextGuideView()
                    .opacity(store.isPresendTextGuide ? 1 : 0)
                    .offset(x: 0, y: store.isPresendTextGuide ? 0 : 4)
                    .padding(.bottom, .s4 * 2)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    {
        let context = RecordCountSummary(year: 2025, monthlyRecords: [:])
        let state = MainStateFactory().makeBottleCalendarState(context: context)
        let store = MainStoreFactory().makeBottleCalendarStore(state: state)
        return BottleCalendarView(store: store)
    }()
}
