//
//  MonthlyRecordResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 7/29/25.
//

import DNetwork

extension MonthlyRecordResponse {
    func toDomain() -> MonthlyRecordState {
        MonthlyRecordState(
            records: self.records?.map { record in
                Record(
                    date: record.date,
                    contents: record.contents?.map {
                        RecordContent(
                            flag: RecordContentType(rawValue: $0.flag),
                            category: RecordCategory(rawValue: $0.category),
                            memo: $0.memo
                        )
                    }
                )
            },
            saveItems: self.saveItems.map {
                Reward(
                    id: $0.id,
                    name: $0.name,
                    imageUrl: $0.imageUrl,
                    jsonUrl: $0.jsonUrl,
                    soundUrl: $0.mp3Url,
                    thumbnailUrl: $0.thumbnailUrl,
                    category: RewardItemCategory(rawValue: $0.category),
                    newAcquiredFlag: $0.newAcquiredFlag,
                    hidden: $0.hidden,
                    hiddenRead: $0.hiddenRead
                )
            },
            hasNotOpenedRewards: self.hasNotOpenedRewards,
            totalExpensesCount: self.totalExpensesCount
        )
    }
}
