//
//  KeychainDataSource.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import Security
import ComposableArchitecture

protocol KeychainDataSource {
    func generateUUID() -> String
    func getUserName() -> String
    func setUserName(name: String)
}

struct DefaultKeychainDataSource: KeychainDataSource {
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
    
    public init() { }
    
    private let debugUUID = "6B788207-4A6A-4B54-A44F-C23853918C09"
    
    /// Keychain에서 UUID 가져오기 (없으면 새로 생성 후 저장)
    // TODO: - 배포 전 확인하기
    public func generateUUID() -> String {
        save(to: .uuid, value: debugUUID)
        if let uuid = load(from: .uuid) {
            return uuid
        }
        return debugUUID
//        let newUUID = load(from: .uuid) ?? UUID().uuidString
//        save(to: .uuid, value: newUUID)
//        return newUUID
    }
    
    /// 사용자 이름 가져오기
    public func getUserName() -> String {
        load(from: .name) ?? ""
    }
    
    /// 사용자 이름 설정하기
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
        
        if status != errSecSuccess { return nil }
        guard let data = dataTypeRef as? Data else { return nil }
        guard let uuid = String(data: data, encoding: .utf8) else { return nil }
        return uuid
    }
}

extension DependencyValues {
    private enum KeychainDataSourceKey: DependencyKey {
        static let liveValue: KeychainDataSource = DefaultKeychainDataSource()
    }
    
    var keychainDataSource: KeychainDataSource {
        get { self[KeychainDataSourceKey.self] }
        set { self[KeychainDataSourceKey.self] = newValue }
    }
}
