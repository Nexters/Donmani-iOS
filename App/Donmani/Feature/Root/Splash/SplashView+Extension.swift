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
            async let downloadTask: () = downloadRewardData()
            do {
                try await userTask
                try await recordTask
                try await rewardTask
                try await downloadTask
            } catch(let e) {
                print(e.localizedDescription)
            }
        }
    }
    
    private func fetchUserData() async throws {
        let user = try await userRepository.registerUser()
        if user.new {
            settings.shouldShowOnboarding = true
        }
    }
    
    private func fetchRecordData() async throws {
        let today = Day.today
        if today.day == 1 {
            async let yesterdayTask: Void = fetchRecordData(at: .yesterday)
            async let todayTask: Void = fetchRecordData(at: .today)
            try await yesterdayTask
            try await todayTask
        } else {
            _ = try await fetchRecordData(at: .today)
        }
    }
    
    private func fetchRecordData(at date: Day) async throws {
        let monthlyRecordState = try await recordRepository.getMonthlyRecordList(
            year: date.year,
            month: date.month
        )
        if let records = monthlyRecordState.records {
            recordRepository.saveRecords(records)
        }
    }
    
    private func fetchRewardData() async throws {
        let today = Day.today
        let equippedItems = try await rewardRepository.getMonthlyRewardItem(
            year: today.year,
            month: today.month
        )
        rewardRepository.saveEquippedItems(
            year: today.year,
            month: today.month,
            items: equippedItems
        )
    }
    
    private func downloadRewardData() async throws {
        let reward = try await rewardRepository.getUserRewardItem()
        for (_, items) in reward {
            rewardRepository.saveRewards(items: items)
            for item in items {
                do {
                    try await fileRepository.saveRewardData(from: item)
                    print("Download Success: \(item.name)")
                } catch(let e) {
                    print("Download Fail: \(item.name). with \(e)")
                }
            }
        }
    }
    
    private func checkAppVersion() {
        Task {
            let infoDictionaryKey = "CFBundleShortVersionString"
            let appVersion = (Bundle.main.infoDictionary?[infoDictionaryKey] as? String) ?? "0.0"
            let updateInfo = try await appVersionRepository.getAppVersion()
            let isLatestVersion = VersionManager().isLastestVersion(store: updateInfo.latestVersion, current: appVersion)
            self.isLatestVersion = isLatestVersion
            if updateInfo.isUpdateRequired {
                if !isLatestVersion {
                    return
                }
            }
            completeHandler?()
        }
    }
}
