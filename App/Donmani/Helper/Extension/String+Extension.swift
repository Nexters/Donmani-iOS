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
}
