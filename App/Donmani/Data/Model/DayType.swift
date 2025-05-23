//
//  DayType.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

enum DayType {
    case today
    case yesterday
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .yesterday:
            return "내일"
        } 
    }
}
