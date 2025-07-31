//
//  RecordRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/28/25.
//

import DNetwork

final actor RecordRepository {
    let service: RecordService
    
    init(service: RecordService) {
        self.service = service
    }
    
    /// 기록 작성
    public func postRecord(userKey: String, record: Record) async throws {
        let bodyData = RecordRequest(userKey: userKey, record: record)
        try await service.postRecord(bodyData: bodyData)
    }
    
    /// 월별 기록 정보(리스트)
    public func getMonthlyRecordList(userKey: String, year: Int, month: Int) async throws -> MonthlyRecordState {
        try await service.getMonthlyRecordList(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월별 기록 정보(캘린더)
    public func getMonthlyRecordCalendar(userKey: String, year: Int, month: Int) async throws -> MonthlyRecordState {
        try await service.getMonthlyRecordCalendar(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월별 행복/후회 기록 개수 통계
    public func getMonthlyRecordStatistics(userKey: String, year: Int, month: Int) async throws -> RecordStatistics {
        try await service.getMonthlyRecordStatistics(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월간 카테고리별 기록 수
    public func getMonthlyCategorySatistics(userKey: String, year: Int, month: Int) async throws -> CategoryStatistics {
        try await service.getMonthlyCategorySatistics(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 연간 기록(별통이 달력)
    public func getYearlyRecordSummary(userKey: String, year: Int) async throws -> SummaryResponse {
        try await service.getYearlyRecordSummary(userKey: userKey, year: year)
    }
}
