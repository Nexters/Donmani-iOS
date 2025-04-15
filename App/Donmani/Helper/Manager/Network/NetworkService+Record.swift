//
//  NetworkService+Record.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkService {
    struct DRecord {
        let request: DNetworkRequest
        let userKey: String
        
        init() {
            self.request = DNetworkRequest()
            self.userKey = NetworkService.userKey
        }
        
        func insert(date: String, recordContent: [RecordContent]?) async throws {
            let bodyData = RecordsDTO(
                userKey: userKey,
                records: [
                    RecordDTO(
                        date: date,
                        contents: recordContent?.map { content in
                            RecordContentDTO(
                                flag: content.flag,
                                category: content.category,
                                memo: content.memo
                            )
                        }
                    )
                ]
            )
            let _ : DResponse<Data> = try await self.request.post(
                path: .expenses,
                bodyData: bodyData
            )
        }
        
        /// 한달 기록 리스트
        func fetchRecordCalendar(year: Int, month: Int) async throws -> [Record] {
            let responseData: DResponse<RecordsDTO> = try await self.request.get(
                path: .expenses,
                addtionalPath: ["list", userKey],
                parameters: ["year": year, "month": month]
            )
            guard let data = responseData.responseData else {
                throw NetworkError.noData
            }
            return data.records?.map { record in
                Record(
                    date: record.date,
                    contents: record.contents?.compactMap{$0}.map { content in
                        RecordContent(
                            flag: content.flag,
                            category: content.category,
                            memo: content.memo
                        )
                    }
                )
            } ?? []
        }
        
        /// 한달 카테고리별 기록 개수
        func fetchCategoryCount(year: Int, month: Int) async throws -> CategoryCountDTO {
            let response: CategoryCountDTO = try await self.request.get(
                path: .expenses,
                addtionalPath: ["category-statistics", userKey],
                parameters: ["year": year, "month": month]
            )
            return response
        }
        
        /// 한달 기록 리스트
        func fetchRecordList(year: Int, month: Int) async throws -> [Record] {
            let responseData: DResponse<RecordsDTO> = try await self.request.get(
                path: .expenses,
                addtionalPath: ["list", userKey],
                parameters: ["year": year, "month": month]
            )
            guard let data = responseData.responseData else {
                throw NetworkError.noData
            }
            return data.records?.map { record in
                Record(
                    date: record.date,
                    contents: record.contents?.compactMap{$0}.map { content in
                        RecordContent(
                            flag: content.flag,
                            category: content.category,
                            memo: content.memo
                        )
                    }
                )
            } ?? []
        }
        
        /// 한달 통계
        func fetchMonthlyStatistics(year: Int, month: Int) async throws -> StatisticsDTO {
            let response: StatisticsDTO = try await self.request.get(
                path: .expenses,
                addtionalPath: ["statistics", userKey],
                parameters: ["year": year, "month": month]
            )
            return response
        }
        
        /// 각 달마다의 기록 개수
        func fetchMonthlyRecordCount(year: Int) async throws -> SummaryDTO {
            let response: SummaryDTO = try await self.request.get(
                path: .expenses,
                addtionalPath: ["summary", userKey],
                parameters: ["year": year]
            )
            return response
        }
    }
}
