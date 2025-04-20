//
//  SplashView+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI
import DNetwork

extension SplashView {
    func loadData() {
        Task {
            let keychainManager = KeychainManager()
            let (key, _) = keychainManager.generateUUID()
//            print(key)
            let isFirstUser = keychainManager.getUserName().isEmpty
            NetworkService.setUserKey(key)
            var userName = try await NetworkService.User().register()
            if isFirstUser {
                userName += "님의 별통이"
            }
            userName = try await NetworkService.User().update(name: userName)
            keychainManager.setUserName(name: userName)
            DataStorage.setUserName(userName)
            let dateManager = DateManager.shared
            var records: [Record] = []
            let recordDAO = NetworkService.DRecord()
            
            let today = dateManager.getFormattedDate(for: .today).components(separatedBy: "-").compactMap(Int.init)
            if (today[2] == 1) {
                let yesterday = dateManager.getFormattedDate(for: .yesterday).components(separatedBy: "-").compactMap(Int.init)
                let response = try await recordDAO.fetchRecordCalendar(year: yesterday[0], month: yesterday[1])
                let result = NetworkDTOMapper.mapper(dto: response)
                records.append(contentsOf: result)
            }
            let response = try await recordDAO.fetchRecordCalendar(year: today[0], month: today[1])
            let result = NetworkDTOMapper.mapper(dto: response)
            records.append(contentsOf: result)
            
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
            let storeVerion = try await NetworkService.Version().fetchAppVersionFromAppStore()
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
