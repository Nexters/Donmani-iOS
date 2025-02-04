//
//  Content.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

struct Content {
    enum ContentType {
        case good
        case bad
    }
    
    enum ContentCategory {
        case food
        case drink
    }
    
    var flag: ContentType
    var category: ContentCategory
    var memo: String
}
