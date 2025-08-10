//
//  VersionManager.swift
//  Donmani
//
//  Created by 문종식 on 3/14/25.
//

public struct VersionManager {
    public func isLastestVersion(store: String, current: String) -> Bool {
        if store == current {
            return true
        }
        let storeComponents = store.split(separator: ".").compactMap { Int($0) }
        let currentComponents = current.split(separator: ".").compactMap { Int($0) }
        
        let maxLength = max(storeComponents.count, currentComponents.count)
        
        for i in 0..<maxLength {
            let storeNum = i < storeComponents.count ? storeComponents[i] : 0
            let currentNum = i < currentComponents.count ? currentComponents[i] : 0
            
            if storeNum == currentNum {
                continue
            }
            if storeNum > currentNum {
                return false
            }
            if storeNum < currentNum {
                return true
            }
        }
        
        return true
    }
    
    deinit {
#if DEBUG
        print("\(#function) \(Self.self)")
#endif
    }
}
