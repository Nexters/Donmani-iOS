//
//  MonthlyStarBottleView.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct MonthlyStarBottleView: View {
    @Bindable var store: StoreOf<MonthlyStarBottleStore>
    
    var body: some View {
        ZStack {
            BackgroundView(colors: [
                DColor.backgroundTop,
                DColor.backgroundBottom,
            ])
            DImage(.mainBackgroundStar).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            
            // Navigation Bar
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    HStack {
                        Spacer()
                        Text("\(store.year)년 \(store.month)월")
                            .font(.b1, .semibold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            store.send(.delegate(.popToPreviousView))
                        }
                        Spacer()
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                Spacer()
                
                ZStack {                    
                    if store.record.isEmpty {
                            DImage(.lockedStarBottle).image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal, 38)
                            VStack {
                                TopBannerView()
                                Spacer()
                            }
                            .padding(.top, .s5)
                            .padding(.horizontal, .defaultLayoutPadding)
                    } else {
                        ZStack {
                            DImage(.starBottleBackground).image
                                .resizable()
                                .frame(width: .screenWidth * 0.9)
                                .aspectRatio(0.75, contentMode: .fit)
                            
                            ZStack {
                                StarBottleView(records: store.record)
                                    .frame(width: .screenWidth * 0.8)
                                    .aspectRatio(0.75, contentMode: .fit)
                                DImage(.starBottle).image
                                    .resizable()
                                    .frame(width: .screenWidth * 0.8)
                                    .aspectRatio(0.75, contentMode: .fit)
                                    .opacity(1)
                            }
                            .onTapGesture {
                                store.send(.delegate(.pushRecordListView(store.year, store.month)))
                            }
                        }
                    }
                    
                }
                
                Spacer()
            }
            
            
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    MonthlyStarBottleView(
        store: Store(initialState: MonthlyStarBottleStore.State(year: 2025, month: 1)) {
            MonthlyStarBottleStore()
        }
    )
}
