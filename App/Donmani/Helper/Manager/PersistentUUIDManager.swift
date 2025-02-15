//
//  PersistentUUIDManager.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import Security

final class PersistentUUIDManager {
    static let shared = PersistentUUIDManager()
    
    private let key = "com.nexters.donmani.app.persistentUUID"
    
    private init() {}
    
    /// Keychain에서 UUID 가져오기 (없으면 새로 생성 후 저장)
    public func getPersistentUUID() -> String {
        if let uuid = loadFromKeychain() {
            return uuid
        } else {
            let newUUID = UUID().uuidString
            saveToKeychain(uuid: newUUID)
            return newUUID
        }
    }
    
    /// Keychain에 UUID 저장
    private func saveToKeychain(uuid: String) {
        let data = Data(uuid.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // 기존 값이 있을 경우 업데이트
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Keychain에서 UUID 불러오기
    private func loadFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let uuid = String(data: data, encoding: .utf8) {
                return uuid
            }
        }
        return nil
    }
}

