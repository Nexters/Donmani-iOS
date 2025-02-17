//
//  NetworkManager+Record.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    struct NMRecord {
        let service: DNetworkService
        
        init (
            service: DNetworkService
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
        
        func fetchRecord(year: Int, month: Int) async throws -> [Record] {
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
    }
}
