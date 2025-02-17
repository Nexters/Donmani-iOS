//
//  DateManager.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

final class DateManager {
    enum FormatType {
        case yearMonth
        case yearMonthDay
        
        var format: String {
            switch self {
            case .yearMonth:
                return "yyyy-MM"
            case .yearMonthDay:
                return "yyyy-MM-dd"
            }
        }
    }
    static let shared = DateManager()
    
    private init() {
        
    }
    
    /// Type에 해당하는 날짜를 yyyy-MM-dd 형식으로 반환
    func getFormattedDate(for type: DayType, _ format: FormatType = .yearMonthDay) -> String {
        let currentDate = Date()
        let targetDate: Date
        switch type {
        case .today:
            targetDate = currentDate
        case .yesterday:
            targetDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.format
        return dateFormatter.string(from: targetDate)
    }
}
