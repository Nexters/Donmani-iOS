//
//  RecordAPI.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct RecordAPI {
    private let request = NetworkRequest()
    
    public init() { }
    
    /// 기록 작성
    public func postRecord(bodyData: RecordRequest) async throws {
        try await request.post(path: .expenses, bodyData: bodyData)
    }
    
    /// 월별 기록 정보(리스트)
    public func getMonthlyRecordList(userKey: String, year: Int, month: Int) async throws -> MonthlyRecordResponse {
        let result: ResponseWrapper<MonthlyRecordResponse> = try await request.get(
            path: .expenses,
            additionalPaths: ["list", userKey],
            parameters: [
                "year": year,
                "month": month
            ]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 월별 기록 정보(캘린더)
    public func getMonthlyRecordCalendar(userKey: String, year: Int, month: Int) async throws -> MonthlyRecordResponse {
        let result: ResponseWrapper<MonthlyRecordResponse> = try await request.get(
            path: .expenses,
            additionalPaths: ["calendar", userKey],
            parameters: [
                "year": year,
                "month": month
            ]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 월별 행복/후회 기록 개수 통계
    public func getMonthlyRecordStatistics(userKey: String, year: Int, month: Int) async throws -> StatisticsResponse {
        let result: ResponseWrapper<StatisticsResponse> = try await request.get(
            path: .expenses,
            additionalPaths: ["statistics", userKey],
            parameters: [
                "year": year,
                "month": month
            ]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 월간 카테고리별 기록 수
    public func getMonthlyCategoryStatistics(userKey: String, year: Int, month: Int) async throws -> CategoryStatisticsResponse {
        let result: ResponseWrapper<CategoryStatisticsResponse> = try await request.get(
            path: .expenses,
            additionalPaths: ["category-statistics", userKey],
            parameters: [
                "year": year,
                "month": month
            ]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    // 연간 기록(별통이 달력)
    public func getYearlyRecordSummary(userKey: String, year: Int) async throws -> SummaryResponse {
        let result: SummaryResponse = try await request.get(
            path: .expenses,
            additionalPaths: ["summary", userKey],
            parameters: ["year": year]
        )
        return result
    }
}
