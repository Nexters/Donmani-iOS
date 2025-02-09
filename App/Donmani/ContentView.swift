//
//  ContentView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ContentView: View {
    var name: String = "행복한 코알라"
    // TODO: - Add Store
    
    var body: some View {
        NavigationStack {
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
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    ZStack {
                        DImage(.starBottle).image
                            .resizable()
                            .aspectRatio(0.75, contentMode: .fit)
                            .frame(width: .screenWidth * 0.8)
                        StarBottleView()
                            .aspectRatio(0.75, contentMode: .fit)
                            .frame(width: .screenWidth * 0.8)
                    }
                    
                    
                    Spacer()
                    
                    RecordButton {
                        LogStore.view(
                            isCompleteToday: false,
                            isCompleteYesterday: false
                        )
                    }
                    
                }
                .padding(.vertical, 16)
            }
        }
        
    }
    
    private func AccessoryButton(
        asset: DImageAsset,
        destination: () -> some View
    ) -> some View {
        NavigationLink{
            destination()
        } label: {
            ZStack {
                Circle()
                    .fill(DColor.accessoryButton)
                    .opacity(0.1)
                DImage(asset).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3)
            }
        }
        .frame(width: 48, height: 48)
    }
    
    private func RecordButton(
        destination: @escaping () -> some View
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            ZStack {
                Circle()
                    .fill(DColor(.pupleBlue70).color)
                DImage(.plus).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s2)                    
            }
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    ContentView()
}
