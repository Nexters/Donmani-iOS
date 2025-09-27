//
//  VersionManagerTests.swift
//  DonmaniTests
//
//  Created by 문종식 on 8/9/25.
//

import Testing

struct VersionManagerTests {
    let versionManager = VersionManager()
    
    @Test
    func compare_equal_version() async throws {
        let currentVersion = "1.17.0"
        let storeVersion = "1.17.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == true)
    }
    
    @Test
    func compare_lower_major_version() async throws {
        let currentVersion = "1.17.3"
        let storeVersion = "2.2.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }
    
    @Test
    func compare_lower_minor_version() async throws {
        let currentVersion = "1.17.0"
        let storeVersion = "1.16.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == true)
    }
    
    @Test
    func compare_lower_build_version() async throws {
        let currentVersion = "1.17"
        let storeVersion = "1.17.3"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }
    
    @Test
    func compare_upper_major_version() async throws {
        let currentVersion = "1.17.3"
        let storeVersion = "2.0.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }

    @Test
    func compare_upper_minor_version() async throws {
        let currentVersion = "1.17.0"
        let storeVersion = "1.18.0"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }

    @Test
    func compare_upper_build_version() async throws {
        let currentVersion = "1.17.0"
        let storeVersion = "1.17.3"
        #expect(versionManager.isLastestVersion(store: storeVersion, current: currentVersion) == false)
    }
}
