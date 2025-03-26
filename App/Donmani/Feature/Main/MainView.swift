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
    @State private var opacity: CGFloat = 0.0
    
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
                            store.send(.delegate(.pushSettingView))
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(store.name)
                            .font(.h1, .bold)
                            .foregroundStyle(DColor(.gray95).color)
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
                            .opacity(opacity)
                        DImage(.starBottle).image
                            .resizable()
                            .frame(width: .screenWidth * 0.8)
                            .aspectRatio(0.75, contentMode: .fit)
                            .opacity(1)
                    }
                    .onTapGesture {
                        store.send(.delegate(.pushRecordListView))
                    }
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
                        Text("오늘 남길 수 있는 기록은 모두 작성했어요!")
                            .font(DFont.font(.b2, weight: .semibold))
                            .foregroundStyle(DColor(.pupleBlue90).color)
                    }
                }
            }
            .padding(.vertical, 16)
            
            if store.isPresentingRecordEntryButton && store.isPresentingPopover {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        guidePopoverView()
                            .frame(width: .screenWidth)
                        
                        Spacer()
                    }
                }.padding(.vertical, 16 + 70 + 5)
            }
            if store.isNewStarBottle {
                NewStarBottleView()
            }
//            if store.isPresentingUpdateApp {
//                AppStoreView()
//            }
            
            if store.isLoading {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            UINavigationController.swipeNavigationPopIsEnabled = false
            store.send(.fetchUserName)
            store.send(.checkPopover)
            Task(priority: .background) {
                try? await Task.sleep(nanoseconds: 2_000_000)
                store.send(.checkNotificationPermission)
                opacity = 1.0
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainView(
        store: Store(initialState: MainStore.State()) {
            MainStore()
        }
    )
}
