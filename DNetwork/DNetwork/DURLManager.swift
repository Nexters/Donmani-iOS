//
//  DURLManager.swift
//  DNetwork
//
//  Created by 문종식 on 3/9/25.
//

public enum DURLManager {
    case privacyPolicy
    case feedback
    case api
    case appInfo
    case appStore
    
    public var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://littlemoom.notion.site/bbs-term?pvs=4"
        case .feedback:
            return "https://forms.gle/G32u2RTKjHM8Fwef7"
        case .api:
            return "http://211.188.60.38:8080"
        case .appInfo:
            return "https://itunes.apple.com/lookup?bundleId=com.nexters.Donmani"
        case .appStore:
            return "itms-apps://itunes.apple.com/kr/app/apple-store/id6741164570"
        }
    }
}
