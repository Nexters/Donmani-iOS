//
//  RecordContentDTO.swift
//  Donmani
//
//  Created by 문종식 on 2/8/25.
//

import Foundation

struct RecordContentDTO: Codable {
    var flag: RecordContentType
    var category: RecordCategory
    var memo: String
    
    init(flag: RecordContentType, category: RecordCategory, memo: String) {
        self.flag = flag
        self.category = category
        self.memo = memo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.flag = try container.decode(RecordContentType.self, forKey: .flag)
        self.memo = try container.decode(String.self, forKey: .memo)

        if flag == .good {
            let goodCategory = try container.decode(GoodCategory.self, forKey: .category)
            self.category = RecordCategory(goodCategory)
        } else if flag == .bad {
            let badCategory = try container.decode(BadCategory.self, forKey: .category)
            self.category = RecordCategory(badCategory)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .category, in: container, debugDescription: "Invalid category for the given flag.")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flag, forKey: .flag)
        try container.encode(memo, forKey: .memo)
        
        if let instance: BadCategory = category.getInstance() {
            try container.encode(instance, forKey: .category)
            return
        }
        
        if let instance: GoodCategory = category.getInstance() {
            try container.encode(instance, forKey: .category)
            return
        }
        
        throw EncodingError.invalidValue(category, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported category type"))
    }
    
    private enum CodingKeys: String, CodingKey {
        case flag, category, memo
    }
}
