//
//  GA+Parameter.swift
//  Donmani
//
//  Created by 문종식 on 4/10/25.
//

extension GA {
    enum Parameter {
        case screenType
        case referrer
        case good
        case bad
        case empty
        case category
        case record
        case streakCount
        case recordStatus
        case notificationType
        case recordID
        case 별통이ID
        
        // Reward
        case reward_배경
        case reward_효과
        case reward_장식
        case reward_별통이
        case reward_효과음
        
        var value: String {
            switch self {
            case .screenType:
                return "screentype"
            case .referrer:
                return "referrer"
            case .good:
                return "good"
            case .bad:
                return "bad"
            case .empty:
                return "empty"
            case .category:
                return "category"
            case .record:
                return "record"
            case .streakCount:
                return "streak_count"
            case .recordStatus:
                return "record_status"
            case .notificationType:
                return "notificationtype"
            case .recordID:
                return "record_id"
            case .별통이ID:
                return "별통이_id"
            case .reward_배경:
                return "배경"
            case .reward_효과:
                return "효과"
            case .reward_장식:
                return "장식"
            case .reward_별통이:
                return "별통이"
            case .reward_효과음:
                return "효과음"
            }
        }
    }
}
