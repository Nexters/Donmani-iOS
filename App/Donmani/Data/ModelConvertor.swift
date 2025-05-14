//
//  ModelConvertor.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

//final class RecordModelConvertor {
//    static func DTOtoDataModel(_ dto: RecordDTO) -> (Record) {
//        Record(
//            date: dto.date,
//            contents: dto.contents?.compactMap{$0}.map { contentDTO in
//                RecordContent(
//                    flag: contentDTO.flag,
//                    category: contentDTO.category,
//                    memo: contentDTO.memo
//                )
//            }
//        )
//    }
//    
//    static func DataModeltoDTO(_ model: Record) -> (RecordDTO) {
//        RecordDTO(
//            date: model.date,
//            contents: model.contents?.map { content in
//                RecordContentDTO(
//                    flag: content.flag,
//                    category: content.category,
//                    memo: content.memo
//                )
//            }
//        )
//    }
//}
