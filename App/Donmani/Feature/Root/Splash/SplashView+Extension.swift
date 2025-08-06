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
            defer {
                checkAppVersion()
            }
            async let userTask: () = fetchUserData()
            async let recordTask: () = fetchRecordData()
            async let rewardTask: () = fetchRewardData()
            do {
                try await userTask
                try await recordTask
                try await rewardTask
            } catch(let e) {
                print(e.localizedDescription)
            }
        }
    }
    
    private func fetchUserData() async throws {
        let user = try await userRepository.registerUser()
        if user.new {
            Settings.shouldShowOnboarding = true
        }
    }
    
    private func fetchRecordData() async throws {
        let today = Day.today
        if today.day == 1 {
            async let yesterdayTask: Void = fetchRecrodData(at: .yesterDay)
            async let todayTask: Void = fetchRecrodData(at: .today)
            try await yesterdayTask
            try await todayTask
        } else {
            _ = try await fetchRecrodData(at: .today)
        }
    }
    
    private func fetchRecrodData(at date: Day) async throws {
        let monthlyRecordState = try await recordRepository.getMonthlyRecordList(
            year: date.year,
            month: date.month
        )
        if let records = monthlyRecordState.records {
            await recordRepository.saveRecords(records)
        }
    }
    
    // TODO
    private func fetchRewardData() async throws {
        let today = Day.today
        let equippedItems = try await rewardRepository.getMonthlyRewardItem(
            year: today.year,
            month: today.month
        )
        await rewardRepository.saveEquippedItems(
            year: today.year,
            month: today.month,
            items: equippedItems
        )
        
        let reward = try await rewardRepository.getUserRewardItem()
        for (category, items) in reward {
            await rewardRepository.saveRewards(items: items)
            
        }
        
        
        let inventoryDTO = try await NetworkService.DReward().reqeustRewardItem()
        let inventory = NetworkDTOMapper.mapper(dto: inventoryDTO)
        //        print(inventory.reduce(into: 0) { $0 += $1.value.count })
        // TODO: Remove Duplicate Code - Total 4 location
        for reward in (inventory[.effect] ?? []) {
            if let _ = DownloadManager.Effect(rawValue: reward.id),
               let contentUrl = reward.jsonUrl {
                let data = try await NetworkService.DReward().downloadData(from: contentUrl)
                let name = RewardResourceMapper(id: reward.id, category: .effect).resource()
                try DataStorage.saveJsonFile(data: data, name: name)
            }
        }
        DataStorage.setInventory(inventory)
    }
    
    private func checkAppVersion() {
        Task {
            let infoDictionaryKey = "CFBundleShortVersionString"
            let appVersion = (Bundle.main.infoDictionary?[infoDictionaryKey] as? String) ?? "0.0"
            let updateInfo = try await NetworkService.Version().fetchAppVersionFromServer()
            let isLatestVersion = VersionManager().isLastestVersion(store: updateInfo.latestVersion, current: appVersion)
            self.isLatestVersion = isLatestVersion
            if updateInfo.forcedUpdateYn == "Y" {
                if !isLatestVersion {
                    return
                }
            }
            completeHandler?()
        }
    }
}
