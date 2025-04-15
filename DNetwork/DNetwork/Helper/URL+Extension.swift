//
//  URL+Extension.swift
//  DNetwork
//
//  Created by 문종식 on 4/15/25.
//

import Foundation

extension URL {
    mutating func add(paths: [String]) {
        for p in paths {
            self.append(path: p)
        }
    }
    
    func addQueryItems(parameters: [String: Any]) -> URL {
        var result: URL = self
        if var components = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            components.queryItems = parameters.map { item in
                URLQueryItem(name: item.key, value: String(describing: item.value))
            }
            result = components.url ?? self
        }
        return result
    }
}
