//
//  DonmaniApp.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import DesignSystem

@main
struct DonmaniApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DFont.loadFonts()
                }
        }
    }
}
