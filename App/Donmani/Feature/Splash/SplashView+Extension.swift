//
//  SplashView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI

extension SplashView {
    func loadData() {
        Task {
            let keychainManager = KeychainManager()
            let (key, _) = keychainManager.generateUUID()
//            print(key)
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
//            let versionDTO = try await NetworkManager.Version(service: .shared).requsetAppVersionFromServer()
//            let serverVersion = versionDTO.responseData["latestVersion", default: appVersion]
//            let isLatestVersion = VersionManager().isLastestVersion(store: , current: appVersion)
//            self.isLatestVersion = isLatestVersion
            let storeVerion = try await NetworkManager.Version(service: .shared).requsetAppVersionFromAppStore()
            let isLatestVersion = VersionManager().isLastestVersion(store: storeVerion, current: appVersion)
            self.isLatestVersion = isLatestVersion
            if isLatestVersion {
                withAnimation(.smooth) {
                    isPresentingSplash = false
                }
            }
        }
    }
    

}
