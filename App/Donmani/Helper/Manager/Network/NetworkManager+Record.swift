//
//  NetworkManager+Record.swift
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

import DNetwork

extension NetworkManager {
    struct Record {
        let service: DNetworkService
        let userKey: String
        let dateManager: DateManager
        
        init (
            service: DNetworkService,
            userKey: String,
            dateManager: DateManager
        ) {
            self.service = service
            self.userKey = userKey
            self.dateManager = dateManager
        }
        
        func uploadRecord(recordContent: [RecordContent]) async throws {
            let bodyData = RecordsDTO(
                userKey: userKey,
                records: [
                    RecordDTO(
                        date: dateManager.getFormattedDate(for: .today),
                        contents: recordContent.map { content in
                            RecordContentDTO(
                                flag: content.flag,
                                category: content.category,
                                memo: content.memo
                            )
                        }
                    )
                ]
            )
            let _: Bool = try await self.service.requestPOST(
                path: .expenses,
                addtionalPath: ["register"],
                bodyData: bodyData
            )
        }
        
        func fetchRecord() async throws {
            
        }
    }
}
