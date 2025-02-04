//
//  ContentView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import DesignSystem

struct ContentView: View {
    var name: String = "행복한 코알라"
    // TODO: - Add Store
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
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
                            SettingView()
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    RecordButton {
                        
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
                    .fill(Color.accessoryButton)
                    .opacity(0.1)
                DImage(asset).image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .s3)
            }
        }
        .frame(width: 48, height: 48)
    }
    
    private func RecordButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(Color("RecordStart"))
                RoundedRectangle(cornerRadius: 2, style: .circular)
                    .fill(Color.white)
                    .frame(width: 18, height: 4)
                RoundedRectangle(cornerRadius: 2, style: .circular)
                    .fill(Color.white)
                    .frame(width: 4, height: 18)
            }
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    ContentView()
}
