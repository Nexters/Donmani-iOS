//
//  NetworkManager+Record.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    struct NMRecord {
        let service: DNetworkRequest
        
        init (
            service: DNetworkRequest
        ) {
            self.service = service
        }
        
        func uploadRecord(date: String, recordContent: [RecordContent]?) async throws {
            let userKey = NetworkManager.userKey
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
            let _ : Data? = try await self.service.requestPOST(
                path: .expenses,
                bodyData: bodyData
            )
        }
        
        func fetchRecordForCalendar(year: Int, month: Int) async throws -> [Record] {
            let userKey = NetworkManager.userKey
            let responseData: RecordsDTO = try await self.service.requestGET(
                path: .expenses,
                addtionalPath: ["calendar", userKey],
                parameters: ["year": year, "month": month]
            )
            return responseData.records?.map { record in
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
        
        func fetchRecordForList(year: Int, month: Int) async throws -> [Record] {
            let userKey = NetworkManager.userKey
            let responseData: RecordsDTO = try await self.service.requestGET(
                path: .expenses,
                addtionalPath: ["list", userKey],
                parameters: ["year": year, "month": month]
            )
            return responseData.records?.map { record in
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
        
        func fetchMonthlyRecord(year: Int) async throws -> SummaryDTO {
            let userKey = NetworkManager.userKey
            let monthlySummary: SummaryDTO = try await self.service.requestGET(
                path: .api,
                addtionalPath: ["v1", "expenses", "summary", userKey],
                parameters: ["year": year]
            )
            return monthlySummary
        }
    }
}
