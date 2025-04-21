//
//  NetworkDTOMapper.swift
//  Donmani
//
//  Created by 문종식 on 4/16/25.
//

import DNetwork

struct NetworkDTOMapper {
    static func mapper(dto: VersionDTO) -> Version {
        let isUpdateRequired = dto.forcedUpdateYn == "Y"
        let version = Version(
            latestVersion: dto.latestVersion,
            isUpdateRequired: isUpdateRequired
        )
        return version
    }
    
    static func mapper(dto: AppInfoDTO) -> String {
        let version = dto.results.first?.version ?? "0.0.0"
        return version
    }
}

// User
extension NetworkDTOMapper {
    static func mapper(dto: UserResigterDTO) -> User {
        let user = User(
            userKey: dto.userKey,
            userName: dto.userName,
            new: dto.new
        )
        return user
    }
    
    static func mapper(dto: UserUpdateDTO) -> String {
        let updatedUserName = dto.updatedUserName
        return updatedUserName
    }
}

// Record
extension NetworkDTOMapper {
    static func mapper(dto: RecordResponseDTO) -> [Record] {
        var result: [Record] = []
        for responseRecord in dto.records {
            let record = mapper(dto: responseRecord)
            result.append(record)
        }
        return result
    }
    
    static func mapper(dto: RecordResponseDTO.RecordDTO) -> Record {
        var recordContentList: [RecordContent]? = nil
        if let responseContents = dto.contents {
            recordContentList = []
            for responseContent in responseContents {
                let recordContent = mapper(dto: responseContent)
                recordContentList?.append(recordContent)
            }
        }
        let record = Record(
            date: dto.date,
            contents: recordContentList
        )
        return record
    }
    
    static func mapper(dto: RecordResponseDTO.RecordContentDTO) -> RecordContent {
        let flag = mapper(flag: dto.flag)
        let category = mapper(type: flag, rawValue: dto.category.lowercased())
        let recordContent = RecordContent(
            flag: flag,
            category: category,
            memo: dto.memo
        )
        return recordContent
    }
    
    static func mapper(flag: String) -> RecordContentType {
        switch flag {
        case "GOOD":
            return .good
        case "BAD":
            return .bad
        default:
            return .good
        }
    }
    
    static func mapper(type: RecordContentType, rawValue: String) -> RecordCategory {
        var category: (any CategoryProtocol) = GoodCategory.growth
        switch type {
        case .good:
            if let goodCategory = GoodCategory(rawValue: rawValue) {
                category = goodCategory
            }
        case .bad:
            if let badCategory = BadCategory(rawValue: rawValue) {
                category = badCategory
            }
        }
        let recordCategory = RecordCategory(category)
        return recordCategory
    }
    
    static func mapper(dto: SummaryDTO) -> RecordCountSummary {
        var monthlyRecords: [Int: RecordCountSummary.Month] = [:]
        for monthlyRecord in dto.monthlyRecords {
            let month = RecordCountSummary.Month(
                recordCount: monthlyRecord.value.recordCount,
                totalDaysInMonth: monthlyRecord.value.totalDaysInMonth
            )
            monthlyRecords[monthlyRecord.key] = month
        }
        let recordCountSummary = RecordCountSummary(
            year: dto.year,
            monthlyRecords: monthlyRecords
        )
        return recordCountSummary
    }
    
    static func mapper(dto: StatisticsDTO) -> RecordStatistics {
        var records: [Record]? = nil
        if let responseRecords = dto.records {
            records = []
            for responseRecord in responseRecords {
                let record = mapper(dto: responseRecord)
                records?.append(record)
            }
        }
        let recordStatistics = RecordStatistics(
            year: dto.year,
            month: dto.month,
            goodCount: dto.goodCount,
            badCount: dto.badCount,
            hasRecords: dto.hasRecords,
            records: records
        )
        return recordStatistics
    }
    
    static func mapper(dto: CategoryCountDTO) -> CategoryStatistics {
        var categoryCounts: [RecordCategory: Int] = [:]
        for item in dto.categoryCounts {
            var category = RecordCategory(GoodCategory.growth)
            if GoodCategory.set.contains(item.key) {
                category = mapper(type: .good, rawValue: item.key)
            } else {
                category = mapper(type: .bad, rawValue: item.key)
            }
            categoryCounts[category] = item.value
        }
        let categoryStatistics = CategoryStatistics(
            year: dto.year,
            month: dto.month,
            categoryCounts: categoryCounts
        )
        return categoryStatistics
    }
}
