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
    @EnvironmentObject private var toastManager: ToastManager
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<BottleCalendarStore>
    
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
                        DText("별통이 모아보기")
                            .style(.b1, .semibold, .white)
                    }
                )
                
                ScrollView {
                    if store.isPresentingTopBanner {
                        TopBannerView()
                    }
                    MonthlyBottleGridView()
                        .padding(.top, 16)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onChange(of: store.toastType) { _, type in
            toastManager.show(type)
            store.send(.completeShowToast)
        }
        .navigationBarBackButtonHidden()
        .background {
            BackgroundView()
        }
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
