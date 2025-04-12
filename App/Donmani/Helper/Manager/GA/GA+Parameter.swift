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
        case notificationType
        case recordID
        case 별통이ID
        
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
            case .notificationType:
                return "notificationtype"
            case .recordID:
                return "record_id"
            case .별통이ID:
                return "별통이_id"
            }
        }
    }
}
