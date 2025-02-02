//
//  ContentView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI

struct ContentView: View {
    var name: String = "행복한 코알라"
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        NavigationLink{
                            SettingView()
                        } label: {
                            AccessoryButton(name: "Setting")
                        }
                        .frame(width: 48, height: 48)
                        
                        Spacer()
                        Text(name+"의 별나라")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        Spacer()
                        
                        NavigationLink{
                            
                        } label: {
                            AccessoryButton(name: "Calendar")
                        }
                        .frame(width: 48, height: 48)
                    }
                    .padding(.horizontal, 20)
                    
//                    Spacer()
//                    VStack(spacing: 10) {
//                        NavigationLink("Go to Haptic Test") {
//                            HapticTestView()
//                        }
//                        NavigationLink("Go to Coin Test") {
//                            CoinTestView()
//                        }
//                    }
                    Spacer()
                    
                    Button {
                        
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
                .padding(.vertical, 16)
            }
        }
        
    }
    
    private func AccessoryButton(name: String) -> some View {
        ZStack {
            Circle()
                .fill(Color.accessoryButton)
                .opacity(0.1)
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
        }
    }
}

#Preview {
    ContentView()
}
