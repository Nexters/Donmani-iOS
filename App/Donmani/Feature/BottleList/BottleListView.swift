//
//  BottleListView.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct BottleListView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<BottleListStore>
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center,spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Spacer()
                        Text("별통이 모아보기")
                            .font(.b1, .semibold)
                            .foregroundStyle(.white)
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
                    TopBannerView()
                    MonthlyBottleGridView()
                        .padding(.top, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    BottleListView(
        store: Store(
            initialState: BottleListStore.State()
        ) {
            BottleListStore()
        }
    )
}
