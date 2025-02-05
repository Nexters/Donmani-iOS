//
//  LogView.swift
//  Donmani
//
//  Created by 문종식 on 2/5/25.
//

import SwiftUI
import ComposableArchitecture

struct LogView: View {
    @Bindable var store: StoreOf<LogReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LogView()
}
