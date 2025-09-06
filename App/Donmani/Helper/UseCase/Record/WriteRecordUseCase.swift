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

struct DefaultWriteRecordUseCase {
    let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    private func hasRecord(on day: Day) -> Bool {
        recordRepository.load(date: day).isSome
    }
}

extension DefaultWriteRecordUseCase: WriteRecordUseCase {
    func canWriteRecord() -> Bool {
        !(hasRecord(on: .today) && hasRecord(on: .yesterday))
    }
}

extension DependencyValues {
    private enum WriteRecordUseCaseKey: DependencyKey {
        static let liveValue: WriteRecordUseCase = {
            @Dependency(\.recordRepository) var recordRepository
            return DefaultWriteRecordUseCase(
                recordRepository: recordRepository
            )
        }()
    }
    
    var writeRecordUseCase: WriteRecordUseCase {
        get { self[WriteRecordUseCaseKey.self] }
        set { self[WriteRecordUseCaseKey.self] = newValue }
    }
}
