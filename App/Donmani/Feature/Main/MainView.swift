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
            MainBackgroundView()
            VStack {
                ZStack {
                    HStack {
                        AccessoryButton(asset: .setting) {
                            SettingView()
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text(store.name + "의 별나라")
                            .font(.b1, .semibold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                .padding(.horizontal, .s4)
                
                Spacer()
                
                ZStack {
                    DImage(.starBottleBackground).image
                        .resizable()
                        .aspectRatio(0.75, contentMode: .fit)
                        .frame(width: .screenWidth * 0.9)
                    DImage(.starBottle).image
                        .resizable()
                        .aspectRatio(0.75, contentMode: .fit)
                        .frame(width: .screenWidth * 0.8)
                        .opacity(0.5)
                    StarBottleView()
                        .aspectRatio(0.75, contentMode: .fit)
                        .frame(width: .screenWidth * 0.8)
                }
                .onTapGesture {
                    store.send(.touchStarBottle)
                }
                
                Spacer()
                
                RecordButton()
            }
            .navigationDestination(isPresented: $store.isPresentingRecordEntryView) {
                RecordEntryPointView(
                    store: Store(
                        initialState: RecordEntryPointStore.State(
                            isCompleteToday: false,
                            isCompleteYesterday: false
                        )
                    ) {
                        RecordEntryPointStore()
                    }
                )
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    MainView(
        store: Store(initialState: MainStore.State()) {
            MainStore()
        }
    )
}
