//
//  SplashLoadView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI

extension SplashLoadView {
    func loadData() {
        Task {
            let keychainManager = KeychainManager()
            let (key, _) = keychainManager.generateUUID()
            let isFirstUser = keychainManager.getUserName().isEmpty
            NetworkManager.userKey = key
            var userName = try await NetworkManager.NMUser(service: .shared).registerUser()
            if isFirstUser {
                userName += "님의 별통이"
            }
            userName = try await NetworkManager.NMUser(service: .shared).updateUser(name: userName)
            keychainManager.setUserName(name: userName)
            DataStorage.setUserName(userName)
            let dateManager = DateManager.shared
            var records: [Record] = []
            let recordDAO = NetworkManager.NMRecord(service: .shared)
            
            let today = dateManager.getFormattedDate(for: .today).components(separatedBy: "-").compactMap(Int.init)
            if (today[2] == 1) {
                let yesterday = dateManager.getFormattedDate(for: .yesterday).components(separatedBy: "-").compactMap(Int.init)
                records.append(contentsOf: try await recordDAO.fetchRecordForCalendar(year: yesterday[0], month: yesterday[1]))
            }
            records.append(contentsOf: try await recordDAO.fetchRecordForCalendar(year: today[0], month: today[1]))
            
            records.forEach { record in
                if (record.date == dateManager.getFormattedDate(for: .today)) {
                    HistoryStateManager.shared.addRecord(for: .today)
                }
                if (record.date == dateManager.getFormattedDate(for: .yesterday)) {
                    HistoryStateManager.shared.addRecord(for: .yesterday)
                }
                DataStorage.setRecord(record)
            }
            
            let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
            let storeVerion = try await NetworkManager.Version(service: .shared).requsetAppVersion()
            self.compareVersion(store: storeVerion, current: appVersion)
            
            withAnimation(.smooth) {
                isLoading = false
            }
        }
    }
    
    private func compareVersion(store: String, current: String) {
        let v1Components = store.split(separator: ".").compactMap { Int($0) }
        let v2Components = current.split(separator: ".").compactMap { Int($0) }
        
        let maxLength = max(v1Components.count, v2Components.count)
        
        for i in 0..<maxLength {
            let num1 = i < v1Components.count ? v1Components[i] : 0
            let num2 = i < v2Components.count ? v2Components[i] : 0
            
            if num1 < num2 {
                isLatestVersion = true
                return
            }
        }
    }
}
