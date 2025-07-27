//
//  DURL.swift
//  DNetwork
//
//  Created by 문종식 on 3/9/25.
//

public typealias DURL = URLType

public enum URLType {
    /// 개인정보처리 약관 Notion URL
    case privacyPolicy
    
    /// 앱 사용 피드백 Google Form URL
    case feedback
    
    /// API URL
    case api
    
    /// App Store Version Check URL
    case appInfo
    
    /// App Store URL
    case appStore
    
    /// 기능 제안 Google Form URL
    case proposeFunction
    
    /// 공지사항 Notion URL
    case notice
    
    /// 리워드 이벤트 피드백 URL
    case rewardFeedback
    
    public var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://nine-wax-dd5.notion.site/1c3be7cd6b968056981fd210ad6c1fa6"
        case .feedback:
            return "https://forms.gle/G32u2RTKjHM8Fwef7"
        case .api:
            return "http://211.188.60.38:8080/api/v1" // "https://www.donmani.kr"
        case .appInfo:
            return "https://itunes.apple.com/lookup?bundleId=com.nexters.Donmani"
        case .appStore:
            return "itms-apps://itunes.apple.com/kr/app/apple-store/id6741164570"
        case .proposeFunction:
            return "https://forms.gle/6of9Y96wY65S9iuL8"
        case .notice:
            return "https://nine-wax-dd5.notion.site/1c3be7cd6b9680aeb006cce982404d96"
        case .rewardFeedback:
            return "https://forms.gle/UJ8BHkGCivPmNQVN7"
        }
    }
}
