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
            BackgroundView(colors: [
                DColor.backgroundTop,
                DColor.backgroundBottom,
            ])
            DImage(.mainBackgroundStar).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            VStack {
                VStack(spacing: .s3) {
                    HStack {
                        AccessoryButton(asset: .setting) {
                            GA.Click(event: .mainSettingButton).send()
                            store.send(.delegate(.pushSettingView))
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        DText(store.name)
                            .style(.h1, .bold, .gray95)
                        Spacer()
                    }
                }
                .padding(.horizontal, .s4)
                
                Spacer(minLength: 86)
                ZStack {
                    DImage(.starBottleBackground).image
                        .resizable()
                        .frame(width: .screenWidth * 0.9)
                        .aspectRatio(0.75, contentMode: .fit)
                    
                    ZStack {
                        StarBottleView(records: store.monthlyRecords)
                            .frame(width: .screenWidth * 0.8)
                            .aspectRatio(0.75, contentMode: .fit)
                            .opacity(store.starBottleOpacity)
                        DImage(.starBottle).image
                            .resizable()
                            .frame(width: .screenWidth * 0.8)
                            .aspectRatio(0.75, contentMode: .fit)
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
                            .foregroundStyle(DColor(.pupleBlue90).color)
                            .frame(width: 22)
                        DText("오늘 남길 수 있는 기록은 모두 작성했어요!")
                            .style(.b2, .semibold, .pupleBlue90)
                    }
                }
            }
            .padding(.vertical, 16)
            
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
        let state = MainStore.State(today: today)
        return MainView(store: Store(initialState: state) { MainStore() } )
    }()
}
