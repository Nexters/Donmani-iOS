//
//  WriteRecordUseCase.swift
//  Donmani
//
//  Created by 문종식 on 8/16/25.
//

import ComposableArchitecture

protocol WriteRecordUseCase {
    func canWriteRecord() -> Bool
}

struct DefaultWriteRecordUseCase: WriteRecordUseCase {
    let recordDataSource: RecordDataSource
    
    init(recordDataSource: RecordDataSource) {
        self.recordDataSource = recordDataSource
    }
    
    func canWriteRecord() -> Bool {
        var day: Day = .today
        let hasTodayRecord = recordDataSource.load(year: day.year, month: day.month, day: day.day).isSome
        day = .yesterday
        let hasYesterdayRecord = recordDataSource.load(year: day.year, month: day.month, day: day.day).isSome
        return hasTodayRecord || hasYesterdayRecord
    }
}

extension DependencyValues {
    private enum WriteRecordUseCaseDependencyKey: DependencyKey {
        static let liveValue: WriteRecordUseCase = {
            @Dependency(\.recordDataSource) var recordDataSource
            return DefaultWriteRecordUseCase(
                recordDataSource: recordDataSource
            )
        }()
    }
    
    var writeRecordUseCase: WriteRecordUseCase {
        get { self[WriteRecordUseCaseDependencyKey.self] }
        set { self[WriteRecordUseCaseDependencyKey.self] = newValue }
    }
}
