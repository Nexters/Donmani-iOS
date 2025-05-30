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
    @Environment(\.dismiss) private var dismiss
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
                        DText("\(store.year % 100)년 \(store.month)월")
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
                            DImage(.byeoltongBackground).image
                                .resizable()
                                .frame(width: .screenWidth * 0.9)
                                .aspectRatio(0.75, contentMode: .fit)
                            
                            ZStack {
                                StarBottleView(records: store.record)
                                    .frame(width: .screenWidth * 0.85)
                                    .aspectRatio(0.75, contentMode: .fit)
                                DImage(.rewardBottleDefault).image
                                    .resizable()
                                    .frame(width: .screenWidth * 0.85)
                                    .aspectRatio(0.75, contentMode: .fit)
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
    {
        let context = MonthlyStarBottleStore.Context(year: 2025, month: 1)
        let state = MainStateFactory().makeMonthlyStarBottleState(context: context)
        let store = MainStoreFactory().makeMonthlyStarBottleStore(state: state)
        return MonthlyStarBottleView(store: store)
    }()
}
