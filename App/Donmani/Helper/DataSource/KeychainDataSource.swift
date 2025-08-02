//
//  KeychainDataSource.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import Security

final class KeychainDataSource {
    private enum DataType {
        case uuid
        case name
        
        var key: String {
            switch self {
            case .uuid: "com.nexters.donmani.app.persistentUUID"
            case .name: "com.nexters.donmani.app.UserName"
            }
        }
    }
    
    public init() {
        
    }
    
    /// Keychain에서 UUID 가져오기 (없으면 새로 생성 후 저장)
    public func generateUUID() -> (key: String, isInitialized: Bool) {
        if let uuid = load(from: .uuid) {
            return (uuid, false)
        } else {
            let newUUID = UUID().uuidString
            save(to: .uuid, value: newUUID)
            return (newUUID, true)
        }
    }
    
    public func getUserName() -> String {
        load(from: .name) ?? ""
    }
    
    public func setUserName(name: String) {
        save(to: .name, value: name)
    }
    
    /// Keychain에 UUID 저장
    private func save(to type: DataType, value: String) {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.key,
            kSecValueData as String: data
        ]
        
        // 기존 값이 있을 경우 업데이트
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Must Be Private
    private func delete(to type: DataType) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.key
        ]
        
        // 기존 값이 있을 경우 업데이트
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Keychain 데이터 삭제 성공: \(type.key)")
        }
    }
    
    /// Keychain에서 UUID 불러오기
    private func load(from type: DataType) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.key,
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

final class KeychainManager {
    enum DataType {
        case uuid
        case name
        
        var key: String {
            switch self {
            case .uuid:
                return "com.nexters.donmani.app.persistentUUID"
            case .name:
                return "com.nexters.donmani.app.UserName"
            }
        }
    }
    
    public init() {
        
    }
    
    /// Keychain에서 UUID 가져오기 (없으면 새로 생성 후 저장)
    public func generateUUID() -> (key: String, isInitialized: Bool) {
        if let uuid = loadValue(from: .uuid) {
            return (uuid, false)
        } else {
            let newUUID = UUID().uuidString
            saveToKeychain(to: .uuid, value: newUUID)
            return (newUUID, true)
        }
    }
    
    public func getUserName() -> String {
        loadValue(from: .name) ?? ""
    }
    
    public func setUserName(name: String) {
        saveToKeychain(to: .name, value: name)
    }
    
    /// Keychain에 UUID 저장
//    private
    func saveToKeychain(to type: DataType, value: String) {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.key,
            kSecValueData as String: data
        ]
        
        // 기존 값이 있을 경우 업데이트
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    // Must Be Private
    public func deleteToKeychain(to type: DataType) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.key
        ]
        
        // 기존 값이 있을 경우 업데이트
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Keychain 데이터 삭제 성공: \(type.key)")
        }
    }
    
    /// Keychain에서 UUID 불러오기
    public func loadValue(from type: DataType) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.key,
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

