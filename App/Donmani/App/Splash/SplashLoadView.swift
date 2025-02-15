//
//  SplashLoadView.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import SwiftUI
import DesignSystem
import DNetwork
import ComposableArchitecture

struct SplashLoadView: View {
    @State var navigationPath = NavigationPath()
    @State var isLoading: Bool = true
    
    var body: some View {
        if isLoading {
            SplashView()
                .onAppear {
                    loadData()
                }
        } else {
            NavigationStack(path: $navigationPath) {
                MainView(
                    store: Store(initialState: MainStore.State()) {
                        MainStore()
                    }
                )
            }
        }
    }
    
    private func loadData() {
        Task {
            DFont.loadFonts()
            let keychainManager = KeychainManager()
            let (key, isFirst) = keychainManager.generateUUID()
            NetworkManager.userKey = key
            if isFirst {
                let newUserName = try await NetworkManager.NMUser(service: .shared).registerUser()
                keychainManager.setUserName(name: newUserName)
            }
            let userName = keychainManager.getUserName()
            DataStorage.setUserName(userName)
            let dateManager = DateManager.shared
            let today = dateManager.getFormattedDate(for: .today).components(separatedBy: "-").compactMap(Int.init)
            let recordDAO = NetworkManager.NMRecord(service: .shared, dateManager: dateManager)
            let records = try await recordDAO.fetchRecord(year: today[0], month: today[1])
            records.forEach { record in
                DataStorage.setRecord(record)
            }
            withAnimation(.smooth) {
                isLoading = false
            }
        }
    }
}

#Preview {
    SplashLoadView()
}
