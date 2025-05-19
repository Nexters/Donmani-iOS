//
//  String+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/15/25.
//

import Foundation

extension String {
    var convertUppercaseFirstChar: String {
        var string = self
        string.removeFirst()
        return (self.first?.uppercased() ?? "") + string
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    var hasFinalConsonant: Bool {
        guard let lastChar = self.last else { return false }
        guard let scalar = lastChar.unicodeScalars.first else { return false }
        let code = scalar.value
        if code >= 0xAC00 && code <= 0xD7A3 {
            let jongseong = (code - 0xAC00) % 28
            return jongseong != 0
        }
        return false
    }
}
