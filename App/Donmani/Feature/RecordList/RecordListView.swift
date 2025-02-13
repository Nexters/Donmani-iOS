//
//  RecordListView.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture

struct RecordListView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RecordListStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(
                alignment: .center,
                spacing: .defaultLayoutPadding
            ) {
                // Navigation Bar
                HStack {
                    DBackButton {
                        dismiss()
                    }
                    Spacer()
                }
                .frame(height: .navigationBarHeight)
            }
            
            ScrollView {
                LazyVStack {
                    
                }
            }
        }
    }
}

#Preview {
    RecordListView(
        store: Store(
            initialState: RecordListStore.State()
        ) {
            RecordListStore()
        }
    )
}
