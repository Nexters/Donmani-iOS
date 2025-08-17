//
//  NetworkRequestDTOMapper.swift
//  Donmani
//
//  Created by 문종식 on 4/18/25.
//

import DNetwork

//struct NetworkRequestDTOMapper {
//    static func mapper(data: [RecordContent]?) -> [RecordRequestDTO.RecordContentDTO]? {
//        return data?.map { recordContent in
//            RecordRequestDTO
//                .RecordContentDTO(
//                    flag: recordContent.flag.rawValue,
//                    category: recordContent.category.uppercaseTitle,
//                    memo: recordContent.memo
//                )
//        }
//    }
//    
//    static func mapper(year: Int, month: Int, item: [RewardItemCategory : Reward]) -> RewardSaveDTO {
//        let dto = RewardSaveDTO(
//            userKey: "",
//            year: year,
//            month: month,
//            backgroundId: item[.background]?.id ?? 0,
//            effectId: item[.effect]?.id ?? 0,
//            decorationId: item[.decoration]?.id ?? 0,
//            byeoltongCaseId: item[.byeoltong]?.id ?? 0,
//            bgmId: item[.sound]?.id ?? 0
//        )
//        return dto
//    }
//}
