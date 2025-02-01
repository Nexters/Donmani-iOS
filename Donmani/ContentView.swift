//
//  ContentView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack(spacing: 10) {
                    NavigationLink("Go to Haptic Test") {
                        HapticTestView()
                    }
                    NavigationLink("Go to Coin Test") {
                        CoinTestView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
