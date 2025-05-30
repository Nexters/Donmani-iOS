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
            do {
                defer {
                    checkAppVersion()
                }
                try await fetchUserData()
//                try await fetchRecordData()
                Record.previewData.forEach {
                    DataStorage.setRecord($0)
                }
                try await fetchRewardInventory()
            } catch(let e) {
                print(e.localizedDescription)
            }
        }
    }
    
    private func fetchUserData() async throws {
        let keychainManager = KeychainManager()
        // keychainManager.saveToKeychain(to: .uuid, value: "6B788207-4A6A-4B54-A44F-C23853918C09")
        let (key, _) = keychainManager.generateUUID()
        // let isFirstUser = keychainManager.getUserName().isEmpty
        NetworkService.setUserKey(key)
        var userName = try await NetworkService.User().register()
        userName = try await NetworkService.User().update(name: userName)
        keychainManager.setUserName(name: userName)
        DataStorage.setUserName(userName)
    }
    
    private func fetchRecordData() async throws {
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
    }
    
    private func fetchRewardInventory() async throws {
        let inventoryDTO = try await NetworkService.DReward().fetchRewardsInventory()
        let inventory = NetworkDTOMapper.mapper(dto: inventoryDTO)
        DataStorage.setInventory(inventory)
    }
    
    private func checkAppVersion() {
        Task {
            let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
            let storeVerion = (try? await NetworkService.Version().fetchAppVersionFromAppStore()) ?? "0.0"
            let isLatestVersion = VersionManager().isLastestVersion(store: storeVerion, current: appVersion)
            self.isLatestVersion = isLatestVersion
            if isLatestVersion {
                completeHandler?()
            }
        }
    }
}
