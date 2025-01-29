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
            NavigationLink("Go to Haptic Test") {
                HapticTestView()
            }
        }
    }
}

#Preview {
    ContentView()
}
