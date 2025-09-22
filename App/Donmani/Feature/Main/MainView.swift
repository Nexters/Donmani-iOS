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
    @EnvironmentObject private var toastManager: ToastManager
    @Bindable var store: StoreOf<MainStore>
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: .s1) {
                    DNavigationBar(
                        leading: {
                            DNavigationBarButton(.setting) {
                                GA.Click(event: .mainSettingButton).send()
                                store.send(.delegate(.pushSettingView))
                            }
                        },
                        trailing: {
                            DNavigationBarButton(.reward) {
                                store.send(.touchRewardButton)
                            }
                        }
                    )
                    DText(store.userName)
                        .style(.h1, .bold, .gray95)
                }
                
                Spacer()
                
                if store.canWriteRecord {
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
            .padding(.bottom, .s3)
            
            if store.isPresentingNewStarBottle {
                NewStarBottleView()
            }
            
            if store.isPresentingAlreadyWrite {
                OnboardingEndView()
            }
            
            if store.isPresentingRewardToolTipView {
                RewardToolTipView()
            }
            
            if store.isLoading {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
            }
        }
        .background {
            StarBottleView(
                records: store.records,
                decorationData: store.decorationData,
                starBottleAction: $store.starBottleAction
            ) {
                GA.Click(event: .mainRecordArchiveButton).send()
                store.send(.delegate(.pushRecordListView))
            }
            .ignoresSafeArea(.container)
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(
        store: Store(
            initialState: MainStateFactory().makeMainState(
                context: MainStore.Context(
                    records: [],
                    hasRecord: (true, true),
                    isPresentingNewStarBottle: false,
                    decorationData: DecorationData(
                        backgroundRewardData: nil,
                        effectRewardData: nil,
                        decorationRewardName: nil,
                        decorationRewardId: nil,
                        bottleRewardId: nil,
                        bottleShape: .default
                    )
                )
            )
        ) {
            MainStore()
        }
    )
}
