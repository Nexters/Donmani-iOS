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
                        AccessoryButton(name: "Setting") {
                            SettingView()
                        }
                        
                        Spacer()
                        Text(name+"의 별나라")
                            .font(.b1, .semibold)
                            .foregroundStyle(.white)
                        Spacer()
                        
                        AccessoryButton(name: "Calendar") {
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
        name: String,
        destination: () -> some View
    ) -> some View {
        NavigationLink{
            destination()
        } label: {
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
