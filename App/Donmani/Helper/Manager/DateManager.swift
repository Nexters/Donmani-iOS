//
//  DateManager.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    
    private init() {
        
    }
    
    func getFormattedDate(for type: DayType) -> String {
        let currentDate = Date()
        let targetDate: Date
        switch type {
        case .today:
            targetDate = currentDate
        case .yesterday:
            targetDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: targetDate)
    }
}
