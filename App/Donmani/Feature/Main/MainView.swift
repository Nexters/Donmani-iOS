//
//  ContentView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct MainView: View {
    @Bindable var store: StoreOf<MainStore>
    
    var body: some View {
        ZStack {
            if let backgroud = store.backgroundResource {
                Color.clear
                    .ignoresSafeArea()
                    .background {
                        DImage(backgroud)
                            .image
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFill()
                            .padding(-5)
                    }
                DImage(.mainBackgroundStar).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            } else {
                BackgroundView(colors: [
                    DColor.backgroundTop,
                    DColor.backgroundBottom,
                ])
                DImage(.mainBackgroundStar).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            }
            
            if let effect = store.decorationItem[.effect] {
                let lottieName = RewardResourceMapper(
                    id: effect.id, category: .effect
                ).resource()
                if !lottieName.isEmpty {
                    GeometryReader { proxy in
                        DLottieView(
                            name: lottieName,
                            loopMode: .loop
                        )
                        .frame(
                            width: proxy.size.width,
                            height: .screenHeight
                        )
                        .ignoresSafeArea()
                    }
                    .allowsHitTesting(false)
                }
            }
            
            VStack {
                VStack(spacing: .s1) {
                    HStack {
                        AccessoryButton(asset: .setting) {
                            GA.Click(event: .mainSettingButton).send()
                            store.send(.delegate(.pushSettingView))
                        }
                        Spacer()
                        AccessoryButton(asset: .reward) {
                            store.send(.touchRewardButton)
                        }
                    }
                    .padding(.vertical, .s5)
                    HStack {
                        Spacer()
                        DText(store.name)
                            .style(.h1, .bold, .gray95)
                        Spacer()
                    }
                }
                .padding(.horizontal, .defaultLayoutPadding)
                
                Spacer(minLength: 86)
                ZStack {
                    DImage(.byeoltongBackground).image
                        .resizable()
                        .frame(width: .screenWidth * 0.9)
                        .aspectRatio(0.8, contentMode: .fit)
                    
                    ZStack {
                        StarBottleView(
                            size: .screenWidth * 0.8,
                            records: store.monthlyRecords,
                            backgroundShape: $store.byeoltongShapeType
                        )
                        .frame(width: .screenWidth * 0.8)
                        .aspectRatio(0.8, contentMode: .fit)
                        .opacity(store.starBottleOpacity)
                        DImage(store.byeoltongImageType).image
                            .resizable()
                            .frame(width: .screenWidth * 0.8)
                            .aspectRatio(0.8, contentMode: .fit)
                            .overlay {
                                if let decoration = store.decorationItem[.decoration] {
                                    let lottieName = RewardResourceMapper(id: decoration.id, category: .decoration).resource()
                                    let offsetY: CGFloat = {
                                        switch store.byeoltongShapeType {
                                        case .rewardBottleBeadsShape:
                                            return -.screenWidth * 0.21 * 0.4
                                        case .rewardBottleFuzzyShape:
                                            return -.screenWidth * 0.21 * 0.1
                                        default:
                                            return -.screenWidth * 0.21 * 0.8
                                        }
                                    }()
                                    let offsetX: CGFloat = {
                                        switch store.byeoltongShapeType {
                                        case .rewardBottleDefaultShape:
                                            return .screenWidth * 0.21 * 0.8
                                        case .rewardBottleFuzzyShape:
                                            return .screenWidth * 0.21
                                        default:
                                            return 0
                                        }
                                    }()
                                    if !lottieName.isEmpty {
                                        if decoration.id == 23 {
                                            VStack {
                                                HStack {
                                                    DImage(.rewardDecorationSpaceVacance)
                                                        .image
                                                        .resizable()
                                                        .aspectRatio(0.67, contentMode: .fit)
                                                        .frame(height: .screenWidth * 0.27)
                                                        .offset(
                                                            x: offsetX,
                                                            y: offsetY
                                                        )
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                    }
                    .onTapGesture {
                        GA.Click(event: .mainRecordArchiveButton).send()
                        store.send(.delegate(.pushRecordListView))
                    }
                }
                .offset(y: store.yOffset)
                .onChange(of: store.isNewStar) { _, _ in
                    store.send(.shakeTwice)
                }
                
                Spacer()
                
                if store.isPresentingRecordEntryButton {
                    RecordButton()
                } else {
                    HStack(spacing: 4) {
                        DImage(.starShape).image
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .frame(width: 22)
                        DText("오늘 남길 수 있는 기록은 모두 작성했어요!")
                            .style(.b2, .semibold, .white)
                    }
                    .background {
                        Ellipse()
                            .fill(DColor.mainToolTipBackgroundColor)
                            .frame(height: 14)
                            .blur(radius: 20.0)
                            .opacity(0.6)
                    }
                }
            }
            .padding(.bottom, .s5)
            

            
            if let decoration = store.decorationItem[.decoration] {
                let lottieName = RewardResourceMapper(id: decoration.id, category: .decoration).resource()
                if !lottieName.isEmpty {
                    if decoration.id == 20 {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                DLottieView(
                                    name: lottieName,
                                    loopMode: .loop
                                )
                                .frame(width: 80, height: 80)
                            }
                        }
                        .allowsHitTesting(false)
                        .padding(.bottom, 70)
                        .padding(.trailing, .defaultLayoutPadding)
                    } else if decoration.id != 23 {
                        VStack {
                            HStack {
                                DLottieView(
                                    name: lottieName,
                                    loopMode: .loop
                                )
                                .frame(width: 80, height: 80)
                                Spacer()
                            }
                            Spacer()
                        }
                        .allowsHitTesting(false)
                        .padding(.top, 140)
                        .padding(.leading, .defaultLayoutPadding)
                    }
                }
            }
            
            if store.isPresentingRecordEntryButton && store.isPresentingRecordYesterdayToopTip {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        RecordYesterdayViewToolTip()
                            .frame(width: .screenWidth)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 16 + 70)
            }
            if store.isPresentingNewStarBottle {
                NewStarBottleView()
            }
            
            if store.isPresentingAlreadyWrite {
                OnboardingEndView()
            }
            
            if store.isPresentingRewardToolTipView {
                RewardToopTipView()
            }
            
            VStack {
                ToastView(title: "꾸미기를 반영했어요", type: .success)
                    .padding(40)
                Spacer()
            }
            .animation(
                .easeInOut(duration: 0.5),
                value: store.isPresentingSaveSuccessToastView
            )
            .opacity(store.isPresentingSaveSuccessToastView ? 1 : 0)
//            .offset(y: store.isPresentingSaveSuccessToastView ? 0 : 5)
            
            if store.isLoading {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            store.send(.fetchUserName)
            store.send(.checkPopover)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    {
        let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
        var state = MainStore.State(today: today)
        state.monthlyRecords = Record.previewData
        return MainView(store: Store(initialState: state) { MainStore() } )
    }()
}
