//
//  DonmaniTests.swift
//  DonmaniTests
//
//  Created by 문종식 on 1/30/25.
//

import Testing
@testable import Donmani

struct DonmaniTests {

    @Test func compareVersionEqual() async throws {
        let versionManager = VersionManager()
        let currentVersion = "1.17.0"
        let storeVersion = "1.17.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == true)
    }
    
    @Test func compareVersionLowerMajor() async throws {
        let versionManager = VersionManager()
        let currentVersion = "1.17.3"
        let storeVersion = "2.2.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }
    
    @Test func compareVersionLowerMinor() async throws {
        let versionManager = VersionManager()
        let currentVersion = "1.17.0"
        let storeVersion = "1.16.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == true)
    }
    
    @Test func compareVersionLowerBuildNumber() async throws {
        let versionManager = VersionManager()
        let currentVersion = "1.17"
        let storeVersion = "1.17.3"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }
    
}
