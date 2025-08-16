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
            async let yesterdayTask: Void = fetchRecrodData(at: .yesterday)
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
    }
    
    private func downloadRewardData() async throws {
        let reward = try await rewardRepository.getUserRewardItem()
        for (_, items) in reward {
            await rewardRepository.saveRewards(items: items)
        }
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
