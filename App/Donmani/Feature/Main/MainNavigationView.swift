//
//  MainNavigationView.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import SwiftUI
import ComposableArchitecture

struct MainNavigationView: View {
    @Bindable var store: StoreOf<MainNavigationStore>
    
    init() {
        self.store = Store(
            initialState: MainNavigationStore.State()
        ) {
            MainNavigationStore()
        }
    }
    
    var body: some View {
        NavigationStackStore(
            path:
        ) {
            MainView(store: store.scope(
                state: \.mainState,
                action: \.mainAction
            ))
        } destination: { store in
            
        }
    }
}

#Preview {
    MainNavigationView()
}
