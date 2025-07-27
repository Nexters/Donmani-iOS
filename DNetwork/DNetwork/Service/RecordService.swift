//
//  RecordService.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

struct RecordService {
    private let request: NetworkRequest
    
    init(request: NetworkRequest) {
        self.request = request
    }
    
    /// 기록 작성
    func postRecord(record: RecordRequest) async throws {
        try await request.post(path: .expenses, bodyData: record)
    }
    
    /// 월별 기록 정보(리스트)
    func getMonthlyRecordList(userKey: String, year: Int, month: Int) async throws -> MonthlyRecordResponse {
        let result: DResponse<MonthlyRecordResponse> = try await request.get(
            path: .expenses,
            addtionalPaths: ["list", userKey],
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
    func getMonthlyRecordCalendar(userKey: String, year: Int, month: Int) async throws -> MonthlyRecordResponse {
        let result: DResponse<MonthlyRecordResponse> = try await request.get(
            path: .expenses,
            addtionalPaths: ["calendar", userKey],
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
    func getMonthlyRecordStatistics(userKey: String, year: Int, month: Int) async throws -> StatisticsResponse {
        let result: DResponse<StatisticsResponse> = try await request.get(
            path: .expenses,
            addtionalPaths: ["statistics", userKey],
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
    func getMonthlyRecordCalendar(userKey: String) async throws -> CategoryStatisticsResponse {
        let result: DResponse<CategoryStatisticsResponse> = try await request.get(
            path: .expenses,
            addtionalPaths: ["category-statistics", userKey]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
    
    // 연간 기록(별통이 달력)
    func getYearlyRecordSummary(userKey: String, year: Int) async throws -> SummaryResponse {
        let result: DResponse<SummaryResponse> = try await request.get(
            path: .expenses,
            addtionalPaths: ["summary", userKey],
            parameters: ["year": year]
        )
        guard let data = result.responseData else {
            throw NetworkError.noData
        }
        return data
    }
}
