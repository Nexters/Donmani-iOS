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
    case proposeFunction
    case notice
    
    public var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://nine-wax-dd5.notion.site/1c3be7cd6b968056981fd210ad6c1fa6"
        case .feedback:
            return "https://forms.gle/G32u2RTKjHM8Fwef7"
        case .api:
            return "http://211.188.60.38:8080"
        case .appInfo:
            return "https://itunes.apple.com/lookup?bundleId=com.nexters.Donmani"
        case .appStore:
            return "itms-apps://itunes.apple.com/kr/app/apple-store/id6741164570"
        case .proposeFunction:
            return "https://forms.gle/6of9Y96wY65S9iuL8"
        case .notice:
            return "https://nine-wax-dd5.notion.site/1c3be7cd6b9680aeb006cce982404d96"
        }
    }
}
