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
            MainBackgroundView(starCount: 6)
            VStack {
                VStack(spacing: .s3) {
                    HStack {
                        AccessoryButton(asset: .setting) {
                            SettingView()
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
                
                Spacer()
                ZStack {
                    DImage(.starBottleBackground).image
                        .resizable()
                        .frame(width: .screenWidth * 0.9)
                        .aspectRatio(0.75, contentMode: .fit)
                    
                    ZStack {
                        DImage(.starBottle).image
                            .resizable()
                            .frame(width: .screenWidth * 0.8)
                            .aspectRatio(0.75, contentMode: .fit)
                            .opacity(0.5)
                        StarBottleView(records: store.monthlyRecords)
                            .frame(width: .screenWidth * 0.8)
                            .aspectRatio(0.75, contentMode: .fit)
                    }
                    .onTapGesture {
                        store.send(.touchStarBottle)
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
            
            if store.isPresentingUpdateApp {
                AppStoreView()
            }
            
            if store.isLoading {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
            }
        }
        .navigationDestination(isPresented: $store.isPresentingRecordEntryView) {
            let recordEntryPointStore = store.scope(state: \.recordEntryPointState, action: \.reciveRecord)
            RecordEntryPointView(store: recordEntryPointStore)
        }
        .navigationDestination(isPresented: $store.isPresentingRecordListView) {
            RecordListView(
                store: Store(initialState: RecordListStore.State()) {
                    RecordListStore()
                }
            )
        }
        .onAppear {
            store.send(.fetchUserName)
            store.send(.checkPopover)
        }
    }
}

#Preview {
    MainView(
        store: Store(initialState: MainStore.State(
            isLatestVersion: false
        )) {
            MainStore()
        }
    )
}
