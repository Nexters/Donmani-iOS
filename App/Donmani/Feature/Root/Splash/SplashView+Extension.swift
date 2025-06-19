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
                try await fetchRecordData()
//                Record.previewData.forEach {
//                    DataStorage.setRecord($0)
//                }
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
        
        let decorationItem = NetworkDTOMapper.mapper(dto: response.saveItems)
        var saveItem: [RewardItemCategory: Reward] = [:]
        for item in decorationItem {
            saveItem[item.category] = item
            if item.category == .sound {
                if let _ = item.soundUrl {
                    let resource = RewardResourceMapper(id: item.id, category: .sound).resource()
                    DataStorage.setSoundFileName(resource)
                }
                break
            }
        }
        DataStorage.setDecorationItem(saveItem)
        
        
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
        let inventoryDTO = try await NetworkService.DReward().reqeustRewardItem()
        let inventory = NetworkDTOMapper.mapper(dto: inventoryDTO)
        // TODO: Remove Duplicate Code - Total 4 location
        for reward in (inventory[.effect] ?? []) {
            if let _ = DownloadManager.Effect(rawValue: reward.id),
               let contentUrl = reward.jsonUrl {
                let data = try await NetworkService.DReward().downloadData(from: contentUrl)
                let name = RewardResourceMapper(id: reward.id, category: .effect).resource()
                try DataStorage.saveJsonFile(data: data, name: name)
            }
        }
//        for (key, value) in inventory {
//            for reward in value {
//                guard let contentUrl = reward.jsonUrl else {
//                    continue
//                }
//                let data = try await NetworkService.DReward().downloadData(from: contentUrl)
//                let name = RewardResourceMapper(id: reward.id, category: key).resource()
//                try DataStorage.saveImageFile(data: data, name: name)
//            }
//        }
        DataStorage.setInventory(inventory)
        
//        let isSoundOn = HistoryStateManager.shared.getSouncState()
//        SoundManager.isSoundOn = isSoundOn
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
