//
//  UIApplication+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/10/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
