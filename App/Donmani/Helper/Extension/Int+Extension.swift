//
//  Int+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

extension Int {
    var isZero: Bool {
        self == 0
    }
    
    var twoDigitString: String {
        String(format: "%02d", self)
    }
}
