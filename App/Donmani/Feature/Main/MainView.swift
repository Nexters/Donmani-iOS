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
    var name: String = "행복한 코알라"
    // TODO: - Add Store
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            VStack {
                HStack {
                    AccessoryButton(asset: .setting) {
                        SettingView()
                    }
                    
                    Spacer()
                    Text(name+"의 별나라")
                        .font(.b1, .semibold)
                        .foregroundStyle(.white)
                    Spacer()
                    
                    AccessoryButton(asset: .calendar) {
                        Text("List")
                    }
                    .hidden()
                }
                .padding(.horizontal, 20)
                
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
                
                Spacer()
                
                RecordButton(value: name)
            }
            .navigationDestination(for: String.self) { _ in
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
    MainView()
}
