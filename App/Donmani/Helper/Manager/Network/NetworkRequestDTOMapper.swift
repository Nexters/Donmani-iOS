//
//  NetworkRequestDTOMapper.swift
//  Donmani
//
//  Created by 문종식 on 4/18/25.
//

import DNetwork

struct NetworkRequestDTOMapper {
    static func mapper(data: [RecordContent]?) -> [RecordRequestDTO.RecordContentDTO]? {
        return data?.map { recordContent in
            RecordRequestDTO
                .RecordContentDTO(
                    flag: recordContent.flag.rawValue,
                    category: recordContent.category.uppercaseTitle,
                    memo: recordContent.memo
                )
        }
    }
}
