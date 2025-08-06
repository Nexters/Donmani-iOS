//
//  RecordRepository.swift
//  Donmani
//
//  Created by 문종식 on 7/28/25.
//

import DNetwork
import ComposableArchitecture

final actor RecordRepository {
    private let dataSource = RecordAPI()
    @Dependency(\.keychainDataSource) private var keychainDataSource
    @Dependency(\.recordDataSource) private var recordDataSource
    
    // KeychainDataSource
    /// 사용자 ID
    private var userKey: String {
        keychainDataSource.generateUUID()
    }
    
    // RecordDataSource
    /// 기록을 저장합니다.
    func save(_ record: Record) async {
        await recordDataSource.save(record)
    }
    
    /// 기록을 불러옵니다.
    func load(date: Day) async -> Record? {
        await recordDataSource.load(year: date.year, month: date.month, day: date.day)
    }
    
    /// 기록 리스트를 저장합니다.
    func saveRecords(_ records: [Record]) async {
        await withTaskGroup(of: Void.self) { group in
            for record in records {
                group.addTask {
                    await self.save(record)
                }
            }
        }
    }
    
    /// 기록 리스트를 불러옵니다.
    func loadRecords(year: Int, month: Int) async -> [Record]? {
        await recordDataSource.loadRecords(year: year, month: month)
    }
    
    // RecordAPI
    /// 기록 작성
    public func postRecord(record: Record) async throws {
        let bodyData = RecordRequest(userKey: userKey, record: record)
        try await dataSource.postRecord(bodyData: bodyData)
    }
    
    /// 월별 기록 정보(리스트)
    public func getMonthlyRecordList(year: Int, month: Int) async throws -> MonthlyRecordState {
        try await dataSource.getMonthlyRecordList(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월별 기록 정보(캘린더)
    public func getMonthlyRecordCalendar(year: Int, month: Int) async throws -> MonthlyRecordState {
        try await dataSource.getMonthlyRecordCalendar(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월별 행복/후회 기록 개수 통계
    public func getMonthlyRecordStatistics(year: Int, month: Int) async throws -> RecordStatistics {
        try await dataSource.getMonthlyRecordStatistics(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 월간 카테고리별 기록 수
    public func getMonthlyCategorySatistics(year: Int, month: Int) async throws -> CategoryStatistics {
        try await dataSource.getMonthlyCategorySatistics(
            userKey: userKey,
            year: year,
            month: month
        ).toDomain()
    }
    
    /// 연간 기록(별통이 달력)
    public func getYearlyRecordSummary(year: Int) async throws -> SummaryResponse {
        try await dataSource.getYearlyRecordSummary(userKey: userKey, year: year)
    }
}
