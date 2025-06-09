//
//  DNetworkService+Record.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

public extension DNetworkService {
    struct DRecord {
        let request: DNetworkRequest
        let userKey: String
        
        public init() {
            self.request = DNetworkRequest()
            self.userKey = DNetworkService.userKey
        }
        
        public func insert(
            date: String,
            recordContent: [RecordRequestDTO.RecordContentDTO]?
        ) async throws {
            let bodyData = RecordRequestDTO(
                userKey: userKey,
                records: [
                    RecordRequestDTO.RecordDTO(
                        date: date,
                        contents: recordContent?.map { content in
                            RecordRequestDTO.RecordContentDTO(
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
        
        /// 각 달마다의 기록 개수
        public func fetchMonthlyRecordCount(year: Int) async throws -> SummaryDTO {
            let response: SummaryDTO = try await self.request.get(
                path: .expenses,
                addtionalPath: ["summary", userKey],
                parameters: ["year": year]
            )
            return response
        }
        
        /// 한달 통계
        public func fetchMonthlyStatistics(year: Int, month: Int) async throws -> StatisticsDTO {
            let response: StatisticsDTO = try await self.request.get(
                path: .expenses,
                addtionalPath: ["statistics", userKey],
                parameters: ["year": year, "month": month]
            )
            return response
        }
        
        /// 한달 기록 리스트
        public func fetchRecordList(year: Int, month: Int) async throws -> RecordResponseDTO {
            let responseData: DResponse<RecordResponseDTO> = try await self.request.get(
                path: .expenses,
                addtionalPath: ["list", userKey],
                parameters: ["year": year, "month": month]
            )
            guard let data = responseData.responseData else {
                throw NetworkError.noData
            }
            return data
        }
        
        /// 한달 카테고리별 기록 개수
        public func fetchCategoryCount(year: Int, month: Int) async throws -> CategoryCountDTO {
            let response: CategoryCountDTO = try await self.request.get(
                path: .expenses,
                addtionalPath: ["category-statistics", userKey],
                parameters: ["year": year, "month": month]
            )
            return response
        }
        
        /// 한달 기록 리스트
        public func fetchRecordCalendar(year: Int, month: Int) async throws -> RecordResponseDTO {
            let responseData: DResponse<RecordResponseDTO> = try await self.request.get(
                path: .expenses,
                addtionalPath: ["list", userKey],
                parameters: ["year": year, "month": month]
            )
            guard let data = responseData.responseData else {
                throw NetworkError.noData
            }
            return data
        }
    }
}
