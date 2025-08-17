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
            if store.records.isEmpty {
                DImage(.lockedStarBottle).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 38)
            } else {
                StarBottleView(
                    records: store.records,
                    decorationItems: store.decorationItem
                )
            }
            // Navigation Bar
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: .s1) {
                    ZStack {
                        HStack {
                            Spacer()
                            DText("\(store.day.year % 100)년 \(store.day.month)월")
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
                }
                
                ZStack {
                    if store.records.isEmpty {
                        VStack {
                            TopBannerView()
                            Spacer()
                        }
                        .padding(.horizontal, .defaultLayoutPadding)
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            //            store.send(.playBackgroundMusic)
        }
    }
}

#Preview {
    {
        let context = MonthlyStarBottleStore.Context(
            day: .today,
            records: [],
            items: [
                Reward(
                    id: 22,
                    name: "",
                    imageUrl: nil,
                    jsonUrl: nil,
                    soundUrl: nil,
                    thumbnailUrl: nil,
                    category: .decoration,
                    newAcquiredFlag: false,
                    hidden: false,
                    resourceType: .image
                )
            ]
        )
        let state = MainStateFactory().makeMonthlyStarBottleState(context: context)
        let store = MainStoreFactory().makeMonthlyStarBottleStore(state: state)
        return MonthlyStarBottleView(store: store)
    }()
}



//            if let backgroud = store.backgroundResource {
//                Color.clear
//                    .ignoresSafeArea()
//                    .background {
//                        DImage(backgroud)
//                            .image
//                            .resizable()
//                            .ignoresSafeArea()
//                            .scaledToFill()
//                            .padding(-5)
//                    }
//                DImage(.mainBackgroundStar).image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
//            } else {
//                BackgroundView(colors: [
//                    DColor.backgroundTop,
//                    DColor.backgroundBottom,
//                ])
//                DImage(.mainBackgroundStar).image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
//            }

//            if let effect = store.decorationItem[.effect] {
//                let lottieName = RewardResourceMapper(
//                    id: effect.id, category: .effect
//                ).resource()
//                if !lottieName.isEmpty {
//                    GeometryReader { proxy in
//                        DLottieView(
//                            name: lottieName,
//                            loopMode: .loop
//                        )
//                        .frame(
//                            width: proxy.size.width,
//                            height: .screenHeight
//                        )
//                        .ignoresSafeArea()
//                    }
//                    .allowsHitTesting(false)
//                }
//            }

//            if let decoration = store.decorationItem[.decoration] {
//                let lottieName = RewardResourceMapper(id: decoration.id, category: .decoration).resource()
//                if !lottieName.isEmpty {
//                    if decoration.id == 20 {
//                        VStack {
//                            Spacer()
//                            HStack {
//                                Spacer()
//                                DLottieView(
//                                    name: lottieName,
//                                    loopMode: .loop
//                                )
//                                .frame(width: 80, height: 80)
//                            }
//                        }
//                        .allowsHitTesting(false)
//                        .padding(.bottom, 70)
//                        .padding(.trailing, .defaultLayoutPadding)
//                    } else {
//                        VStack {
//                            HStack {
//                                DLottieView(
//                                    name: lottieName,
//                                    loopMode: .loop
//                                )
//                                .frame(width: 80, height: 80)
//                                Spacer()
//                            }
//                            Spacer()
//                        }
//                        .allowsHitTesting(false)
//                        .padding(.top, 100)
//                        .padding(.leading, .defaultLayoutPadding)
//                    }
//                }
//            }
//VStack {
//    Spacer(minLength: 86)
//    ZStack {
//        if store.record.isEmpty {
//            DImage(.lockedStarBottle).image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding(.horizontal, 38)
//        } else {
//            ZStack {
//                DImage(.byeoltongBackground).image
//                    .resizable()
//                    .frame(width: .screenWidth * 0.9)
//                    .aspectRatio(0.8, contentMode: .fit)
//
//                ZStack {
//                    StarBottleView(
//                        size: .screenWidth * 0.8,
//                        records: store.record,
//                        backgroundShape: .constant(store.byeoltongShapeType)
//                    )
//                    .frame(width: .screenWidth * 0.8)
//                    .aspectRatio(0.8, contentMode: .fit)
//                    DImage(store.byeoltongImageType).image
//                        .resizable()
//                        .frame(width: .screenWidth * 0.8)
//                        .aspectRatio(0.8, contentMode: .fit)
//                        .overlay {
//                            if let decoration = store.decorationItem[.decoration] {
//                                let lottieName = RewardResourceMapper(id: decoration.id, category: .decoration).resource()
//                                let offsetY: CGFloat = {
//                                    switch store.byeoltongShapeType {
//                                    case .rewardBottleBeadsShape:
//                                        return -.screenWidth * 0.21 * 0.6
//                                    case .rewardBottleFuzzyShape:
//                                        return 0
//                                    default:
//                                        return -.screenWidth * 0.21 * 0.6
//                                    }
//                                }()
//                                if !lottieName.isEmpty {
//                                    if decoration.id == 23 {
//                                        VStack {
//                                            HStack {
//                                                DImage(.rewardDecorationSpaceVacance)
//                                                    .image
//                                                    .resizable()
//                                                    .aspectRatio(0.67, contentMode: .fit)
//                                                    .frame(height: .screenWidth * 0.21)
//                                                    .offset(
//                                                        x: (store.byeoltongShapeType == .rewardBottleDefaultShape
//                                                            ||
//                                                            store.byeoltongShapeType == .rewardBottleFuzzyShape)
//                                                        ? .screenWidth * 0.21 * 0.8
//                                                        : 0,
//                                                        y: offsetY
//                                                    )
//                                            }
//                                            Spacer()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                }
//                .onTapGesture {
//                    store.send(.delegate(.pushRecordListView(store.year, store.month)))
//                }
//            }
//        }
//    }
//    Spacer()
//}
